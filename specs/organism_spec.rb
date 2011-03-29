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

  it "shoud randomize all modifiables" do
    org1 = Organism.new([:mod1, :mod2])
    expect{ org1.randomize_all }.to change{ org1[:mod1] }
    expect{ org1.randomize_all }.to change{ org1[:mod2] }
  end

  it "shoud randomize all modifiables" do
    org1 = Organism.new([:mod1, :mod2])
    expect{ org1.randomize(:mod1) }.to change{ org1[:mod1] }
    expect{ org1.randomize(:mod1) }.not_to change{ org1[:mod2] }
  end

  it "should raise an exception when you ask for an invalid modifiable" do
    org1 = Organism.new([:mod1, :mod2])
    expect{ a = org1[:mod4] }.to raise_error
    expect{ a = org1[:mod1] }.not_to raise_error
  end

  it "should raise an exception when you try to set an invalid modifiable" do
    org1 = Organism.new([:mod1, :mod2])
    expect{ org1[:mod4]=1.3 }.to raise_error
    org1.add_modifiable(:mod4, 0)
    expect{ org1[:mod4]=1.3 }.not_to raise_error
  end
end
