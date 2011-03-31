require "rspec"
require "organism"
require "limit_spec_helpers"

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
    expect{ org1[:mod4]=0.5 }.to raise_error
    org1.add_modifiable(:mod4, 0)
    expect{ org1[:mod4]=0.5 }.not_to raise_error
  end
  
  it "should accept a minimum and maximum for a given modifiable" do
    org1 = Organism.new([:mod1, :mod2])
    org1.set_min_max_range(:mod1, -2, 1)
    expect_organism_obeys_limits(org1, :mod1, -2, 1)
    expect_organism_obeys_limits(org1, :mod2, 0, 1)
    
    expect{ org1[:mod1] = -3.3 }.to raise_error
    expect{ org1[:mod1] = -0.2 }.not_to raise_error
  end
  
  it "should accept a minimum and maximum for all modifiables" do
    org1 = Organism.new([:mod1, :mod2, :mod3, :mod4])
    org1.set_min_max_range_for_all(-2, 1)
    expect_organism_obeys_limits(org1, org1.modifiables, -2, 1)
    
    org1.modifiables.each do |key|
      expect{ org1[key] = -3.3 }.to raise_error
      expect{ org1[key] = -0.2 }.not_to raise_error
    end
  end
  
  it "should accept a discreet set of possible values (as a range) for a given modifiable" do
    org1 = Organism.new([:mod1, :mod2])
    org1.set_discrete_range(:mod1, -2..3)
    expect_organism_obeys_limits(org1, :mod1, (-2..3).to_a)
    expect_organism_obeys_limits(org1, :mod2, 0, 1)
    
    expect{ org1[:mod1] = -3.3 }.to raise_error
    expect{ org1[:mod1] = -3 }.to raise_error
    expect{ org1[:mod1] = -1 }.not_to raise_error
  end
  
  it "should accept a discreet set of possible values (as an array) for a given modifiable" do
    org1 = Organism.new([:mod1, :mod2])
    org1.set_discrete_range(:mod1, -2, -1, 0, 1, 2, 3)
    expect_organism_obeys_limits(org1, :mod1, (-2..3).to_a)
    expect_organism_obeys_limits(org1, :mod2, 0, 1)
    
    expect{ org1[:mod1] = -3.3 }.to raise_error
    expect{ org1[:mod1] = -3 }.to raise_error
    expect{ org1[:mod1] = -1 }.not_to raise_error
  end
  
  it "should accept a discreet set of possible values (as a Range) for all modifiable" do
    org1 = Organism.new([:mod1, :mod2, :mod3, :mod4])
    org1.set_discrete_range_for_all(-2..3)
    expect_organism_obeys_limits(org1, org1.modifiables, (-2..3).to_a)
    
    org1.modifiables.each do |key|
      expect{ org1[key] = -3.3 }.to raise_error
      expect{ org1[key] = -3 }.to raise_error
      expect{ org1[key] = 1.1 }.to raise_error
      expect{ org1[key] = -1 }.not_to raise_error
    end
  end
  
  it "should accept a discreet set of possible values (as an array) for all modifiable" do
    org1 = Organism.new([:mod1, :mod2, :mod3, :mod4])
    org1.set_discrete_range_for_all([-2, -1, 0, 1, 2, 3])
    expect_organism_obeys_limits(org1, org1.modifiables, (-2..3).to_a)
    
    org1.modifiables.each do |key|
      expect{ org1[key] = -3.3 }.to raise_error
      expect{ org1[key] = -3 }.to raise_error
      expect{ org1[key] = 1.1 }.to raise_error
      expect{ org1[key] = -1 }.not_to raise_error
    end
  end
  
  it "should accept a discreet set of possible values (as an array) for all modifiable" do
    org1 = Organism.new([:mod1, :mod2, :mod3, :mod4])
    org1.set_discrete_range_for_all(-2, -1, 0, 1, 2, 3)
    expect_organism_obeys_limits(org1, org1.modifiables, (-2..3).to_a)
    
    org1.modifiables.each do |key|
      expect{ org1[key] = -3.3 }.to raise_error
      expect{ org1[key] = -3 }.to raise_error
      expect{ org1[key] = 1.1 }.to raise_error
      expect{ org1[key] = -1 }.not_to raise_error
    end
  end
  
  it "should raise an error if the discrete set is of 0 length" do
    org1 = Organism.new([:mod1, :mod2, :mod3, :mod4])
    expect { org1.set_discrete_range(:mod1, -2, -1, 0, 1, 2, 3) }.not_to raise_exception
    expect { org1.set_discrete_range(:mod1, -2) }.not_to raise_exception
    expect { org1.set_discrete_range(:mod1) }.to raise_exception
    expect { org1.set_discrete_range(:mod1, []) }.to raise_exception
    expect { org1.set_discrete_range_for_all }.to raise_exception
    expect { org1.set_discrete_range_for_all([]) }.to raise_exception
  end
  
  it "should raise an error if the discrete set does not consist of Numerics" do
    org1 = Organism.new([:mod1, :mod2, :mod3, :mod4])
    expect { org1.set_discrete_range(:mod1, -2, -1, 0, 1, 2, 3) }.not_to raise_exception
    expect { org1.set_discrete_range(:mod1, -2, -1.2) }.not_to raise_exception
    expect { org1.set_discrete_range(:mod1, -2) }.not_to raise_exception
    expect { org1.set_discrete_range(:mod1, -2, -1, 1..5, 1, 2, 3) }.to raise_exception
    expect { org1.set_discrete_range(:mod1, -2, "four point three") }.to raise_exception
  end
end
