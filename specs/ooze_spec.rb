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

    org2[:mod1] = 1
    org2[:mod2] = 1

    oo.get_score(org1).should == 1
    oo.get_score(org2).should == 3
    oo.get_score(org3).should == 2.2

    oo.get_best.should == org2
  end

  it "should have a method that allows for a randomization of all modifiables in all organism" do
    oo = Ooze.new(3, :mod1, :mod2)
    expect { oo.randomize_all }.to change { oo.population[0][:mod1] }
    expect { oo.randomize_all }.to change { oo.population[0][:mod2] }
    expect { oo.randomize_all }.to change { oo.population[1][:mod1] }
    expect { oo.randomize_all }.to change { oo.population[1][:mod2] }
    expect { oo.randomize_all }.to change { oo.population[2][:mod1] }
    expect { oo.randomize_all }.to change { oo.population[2][:mod2] }
  end

  it "should have a method that allows for a randomization of specific modifiables in all organism" do
    oo = Ooze.new(3, :mod1, :mod2)
    expect { oo.randomize(:mod2) }.not_to change { oo.population[0][:mod1] }
    expect { oo.randomize(:mod2) }.to change { oo.population[0][:mod2] }
    expect { oo.randomize(:mod2) }.not_to change { oo.population[1][:mod1] }
    expect { oo.randomize(:mod2) }.to change { oo.population[1][:mod2] }
    expect { oo.randomize(:mod2) }.not_to change { oo.population[2][:mod1] }
    expect { oo.randomize(:mod2) }.to change { oo.population[2][:mod2] }
  end
  
  def expect_population_obeys_limits(oo, mod_keys, min_or_discrete, max=nil)
    oo.population.each { |org| expect_organism_obeys_limits(org, mod_keys, min_or_discrete, max) }
  end

  def expect_organism_obeys_limits(org, mod_keys, min_or_discrete, max=nil)
    mod_keys = [mod_keys].flatten
    100.times do
      org.randomize_all
      mod_keys.each do |key|
        if(max)
          min = min_or_discrete
          org[key].should be >= min
          org[key].should be <= max
          expect { org[key]=(min+max)/2.0}.not_to raise_error
          expect { org[key]=min-1}.to raise_error
          expect { org[key]=max+1}.to raise_error
        else
          min_or_discrete.should include(org[key])
          min_or_discrete.each do |v|
            expect { org[key]=v }.not_to raise_error
          end
          (-100..100).each do |v|
            unless min_or_discrete.include?(v)
              expect { org[key]=v }.to raise_error
            end
          end
        end
      end
    end
  end

  it "should have a method that allows the min/max range for all modifiables in all organisms to be set" do
    oo = Ooze.new(3, :mod1, :mod2)
    oo.set_min_max_range_for_all(1, 3)
    # expect_population_obeys_limits(oo, [:mod1, :mod2], 1, 3)
    100.times do
      oo.randomize_all
      oo.population.each do |org|
        org[:mod1].should be >= 1
        org[:mod1].should be <= 3
        org[:mod2].should be >= 1
        org[:mod2].should be <= 3
        
        expect { org[:mod1]=100}.to raise_error
      end
    end
    
    oo.set_min_max_range_for_all(3, 1)
    100.times do
      oo.randomize_all
      oo.population.each do |org|
        org[:mod1].should be >= 1
        org[:mod1].should be <= 3
        org[:mod2].should be >= 1
        org[:mod2].should be <= 3
        
        expect { org[:mod1]=100}.to raise_error
      end
    end
  end

  it "should have a method that allows the min/max range for given modifiables in all organisms to be set" do
    oo = Ooze.new(3, :mod1, :mod2)
    oo.set_min_max_range(:mod2, 1, 3)
    oo.population.each do |org|
      100.times do
        oo.randomize_all
        org[:mod2].should be >= 1
        org[:mod2].should be <= 3
      end
    end
  end

  it "should have a method that allows the discrete range for given modifiables in all organisms to be set" do
    oo = Ooze.new(3, :mod1, :mod2)
    oo.set_discrete_range(:mod2, 1, 2, 3, 5)
    oo.population.each do |org|
      100.times do
        oo.randomize_all
        [1, 2, 3, 5].should include(org[:mod2])
      end
    end
  end

  it "should have a method that allows the discrete range for all modifiables in all organisms to be set" do
    oo = Ooze.new(3, :mod1, :mod2)
    oo.set_discrete_range_for_all(1, 2, 3, 5)
    oo.population.each do |org|
      100.times do
        oo.randomize_all
        [1, 2, 3, 5].should include(org[:mod1])
        [1, 2, 3, 5].should include(org[:mod2])
      end
    end
  end

  it "should return the current best organism, which should have a higher score than the other ones" do
    #pending
  end
end
