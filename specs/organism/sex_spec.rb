require "rspec"
require "organism"

describe "Organism Sex" do
  it "should raise an error if it mates with an organism with different modifiables" do
    org1 = Organism.new(:mod1, :mod2)
    org2 = Organism.new(:mod2, :mod3)
    org3 = Organism.new(:mod2, :mod1)
    org4 = Organism.new(:mod2)
    org5 = Organism.new(:mod1, :mod2, :mod3)
    
    expect{ org1.mate_with(org2) }.to raise_error
    expect{ org2.mate_with(org1) }.to raise_error
    expect{ org1.mate_with(org3) }.not_to raise_error
    expect{ org2.mate_with(org3) }.to raise_error
    expect{ org1.mate_with(org4) }.to raise_error
    expect{ org3.mate_with(org4) }.to raise_error
    expect{ org1.mate_with(org5) }.to raise_error
  end
  
  it "should create an organism with the same modifiables" do
    org1 = Organism.new(:mod1, :mod2)
    org2 = Organism.new(:mod1, :mod2)
    org1.mate_with(org2).compatible_with?(org2).should == true
  end
  
  it "should create an organism with the modifiable values from one parent or another" do
    org1 = Organism.new(:mod1, :mod2)
    org2 = Organism.new(:mod1, :mod2)
    org1.randomize_all
    org2.randomize_all
    
    child = org1.mate_with(org2)
    child.compatible_with?(org2).should == true
    child.modifiables.each{|key| [org1[key], org2[key]].should include(child[key])}
  end
  
  it "should mutate an organism slowly" do
    org1 = Organism.new(:mod1, :mod2)
    org1.randomize_all
    expect{ 100.times{ org1 = org1.mutate_to_child } }.to change{ org1 }
  end
end