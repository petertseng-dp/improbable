# Given a set of variables A, B, C,
# assign each variable an index 0, 1, 2...
# The Venn diagram has 2**N regions.
# The bit pattern of region R tells the truth value of the variables at R.
# For example, with the three variables above, region 6 (110) is C true, B true, A false
class VennDiagram
  CERTAINTY = 100_u32

  @var_indices : Hash(String, Int32)

  # We may know the probabilities of any union of regions.
  #
  # For example, if we are told that P(v_0) = 40 (and there are two variables)
  # this represents that regions 1 and 3 sum to 40,
  # since v_0 is index 0 and this tells us that bit 0 is on.
  #
  # If we are told that P(v_0 & v_1) = 20,
  # this represents region 3 is 20.
  #
  # This should tell us our memory requirement is 2**(2**N)
  # e.g. with 3 variables we have 8 regions and 128 subsets of those regions.
  @knowns : Hash(Set(UInt32), UInt32)

  def initialize(@vars : Array(String))
    @var_indices = @vars.each_with_index.to_h
    all_regions = (0_u32...size).to_set
    @knowns = {all_regions => CERTAINTY}
  end

  def size : UInt32
    2_u32 ** @vars.size
  end

  def learn(fact : String)
    vars, probability = fact.split(": ")
    learn_and_infer(regions_of(vars), probability.to_u32, "GIVEN")
  end

  def query(question : String) : UInt32?
    puts "I now know #{@knowns.size} region-sets"
    @knowns[regions_of(question)]?
  end

  def regions_of(vars : String) : Set(UInt32)
    vars = vars.split(" & ")
    known_values = vars.map { |v|
      v[0] == '!' ? {false, @var_indices[v[1..-1]]} : {true, @var_indices[v]}
    }
    known_portion = known_values.map { |on, pos| (on ? 1_u32 : 0_u32) << pos }.reduce(0_u32) { |a, b| a | b }
    unknown_bits = (0...@vars.size).to_set - known_values.map { |_, pos| pos }.to_set
    regions = unknown_bits.reduce([known_portion]) { |regs, bit| regs.flat_map { |r| [r, r | (1_u32 << bit)] } }.to_set
  end

  private def learn_and_infer(regions : Set(UInt32), probability : UInt32, comment : String)
    if @knowns[regions]?
      raise "At #{regions}, known value #{@knowns[regions]} conflicts with new value of #{probability}" if @knowns[regions] != probability
      return
    end

    puts "\e[1m#{comment}\e[0m: #{regions} = #{probability}"

    @knowns[regions] = probability

    @knowns.each { |kr, kv|
      if !regions.intersects?(kr)
        learn_and_infer(regions | kr, probability + kv, "#{regions} (#{probability}) disjoint with #{kr} (#{kv})")
      elsif regions.proper_subset?(kr)
        learn_and_infer(kr - regions, kv - probability, "#{regions} (#{probability}) subset of #{kr} (#{kv})")
      end
    }
  end
end
