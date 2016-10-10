require "spec"
require "../src/venn_diagram"

describe VennDiagram do
  it "does sample 1" do
    vd = VennDiagram.new(["B1", "B2"])
    [
      "!B1 & B2: 1",
      "!B1 & !B2: 85",
      "B2: 12",
    ].each { |l| vd.learn(l) }
    vd.query("B1 & !B2").should eq(3)
  end

  it "does sample 2" do
    vd = VennDiagram.new(["A", "B", "C"])
    [
      "B: 70",
      "C: 27",
      "A & B & !C: 0",
      "A & C & !B: 0",
      "A & !B & !C: 13",
      "!A & !B & !C: 10",
    ].each { |l| vd.learn(l) }
    vd.query("B & C").should eq(20)
  end

  it "admits when it does not know" do
    vd = VennDiagram.new(["A", "B"])
    vd.learn("A & B: 50")
    vd.query("A").should be_nil
  end
end
