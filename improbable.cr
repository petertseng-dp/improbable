require "./src/venn_diagram"

if ARGV.empty?
  puts "usage: #{PROGRAM_NAME} input"
  exit(1)
end

raw_lines = File.read_lines(ARGV[0])
vars = raw_lines[0].chomp.split(' ')
learn_lines = vars.shift.to_i
venn = VennDiagram.new(vars)
raw_lines[1..learn_lines].each { |l|
  venn.learn(l)
}
raw_lines[(learn_lines + 1)..-1].each { |l|
  puts l
  puts venn.query(l.chomp) || "I don't know"
}
