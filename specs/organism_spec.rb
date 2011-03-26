require "rspec"
require "organism"

describe "Organism" do
  it "should be create with no modifiables" do
    org = Organism.new
    org.modifiables.should have(0).items
  end
  
  it "should be create with modifiables" do
    org = Organism.new(:mod1, :mod2)
    org.modifiables.should have(2).items
    org.is_modifiable?(:mod1).should == true
    org.is_modifiable?(:mod2).should == true
    org.is_modifiable?(:mod3).should == false
    
    org = Organism.new([:mod1, :mod2])
    org.modifiables.should have(2).items
    org.is_modifiable?(:mod1).should == true
    org.is_modifiable?(:mod2).should == true
    org.is_modifiable?(:mod3).should == false
  end
  
  it "shoud be equal to itself" do
    org1 = Organism.new([:mod1, :mod2])
    org1.randomize_all
    org2 = org1
    org1.should == org1
  end
  
  it "shoud be equal to an identical organism" do
    org1 = Organism.new([:mod1, :mod2])
    org1.randomize_all
    org2 = Organism.new(:mod1, :mod2)
    
    org2[:mod1] = org1[:mod1]
    org2[:mod2] = org1[:mod2]
    
    org1.should == org2
    
    org2[:mod1] = org1[:mod1] = 0.3
    org2[:mod2] = org1[:mod2] = 0.2
    
    org1.should == org2
  end
end