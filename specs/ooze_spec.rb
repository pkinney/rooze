require "rspec"
require "ooze"

describe "Ooze" do
  it "should build an Ooze of no organisms if no size is passed to it" do
    oo = Ooze.new
    oo.should_not be_nil
  end

  it "should build an Ooze of a given size" do
    oo = Ooze.new(42)
    oo.population.should have(42).items
  end

   it "should build an Ooze of a given size, and each organism should be unique" do
    oo = Ooze.new(42)
    oo.population.should have(42).items
    oo.population.uniq.should have(42).items
  end

  it "should build an Ooze of a given number of Organisms" do
    oo = Ooze.new(42)
    oo.population.each{|org| org.is_a?(Organism).should == true}
  end

  it "should build an Ooze of a given number of Organisms with given modifiables" do
    oo = Ooze.new(42, :mod1, :mod2)
    oo.population.each{|org| org.is_modifiable?(:mod1).should == true}
    oo.population.each{|org| org.is_modifiable?(:mod2).should == true}
    oo.population.each{|org| org.is_modifiable?(:mod3).should == false}
  end

  it "should build an Ooze of with a custom score function" do
    oo = Ooze.new(3, :mod1, :mod2) {|org| org[:mod1] + 2*org[:mod2]}
    org1 = oo.population[0]
    org2 = oo.population[1]
    org3 = oo.population[2]
    
    org1[:mod1] = 1
    org1[:mod2] = 0
    org2[:mod1] = 1
    org2[:mod2] = 0.2
    org3[:mod1] = 1
    org3[:mod2] = 0.6
    
    oo.get_score(org1).should == 1
    oo.get_score(org2).should == 1.4
    oo.get_score(org3).should == 2.2
    oo.get_best.should == org3
    
    org2[:mod1] = 3
    org2[:mod2] = 0.2
    
    oo.get_score(org1).should == 1
    oo.get_score(org2).should == 3.4
    oo.get_score(org3).should == 2.2
    
    oo.get_best.should == org2
  end
  
  it "should have a method that allos for a randomization of all modifiables in all organism" do
    oo = Ooze.new(3, :mod1, :mod2)
    expect { oo.randomize_all }.to change { oo.population[0][:mod1] }
    expect { oo.randomize_all }.to change { oo.population[0][:mod2] }
    expect { oo.randomize_all }.to change { oo.population[1][:mod1] }
    expect { oo.randomize_all }.to change { oo.population[1][:mod2] }
    expect { oo.randomize_all }.to change { oo.population[2][:mod1] }
    expect { oo.randomize_all }.to change { oo.population[2][:mod2] }
  end
  
  it "should have a method that allos for a randomization of specific modifiables in all organism" do
    oo = Ooze.new(3, :mod1, :mod2)
    expect { oo.randomize(:mod2) }.not_to change { oo.population[0][:mod1] }
    expect { oo.randomize(:mod2) }.to change { oo.population[0][:mod2] }
    expect { oo.randomize(:mod2) }.not_to change { oo.population[1][:mod1] }
    expect { oo.randomize(:mod2) }.to change { oo.population[1][:mod2] }
    expect { oo.randomize(:mod2) }.not_to change { oo.population[2][:mod1] }
    expect { oo.randomize(:mod2) }.to change { oo.population[2][:mod2] }
  end

  it "should return the current best organism, which should have a higher score than the other ones" do
    #pending
  end
end