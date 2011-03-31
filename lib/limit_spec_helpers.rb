require "rspec"

def expect_population_obeys_limits(oo, mod_keys, min_or_discrete, max=nil)
  oo.population.each { |org| expect_organism_obeys_limits(org, mod_keys, min_or_discrete, max) }
end

def expect_organism_obeys_limits(org, mod_keys, min_or_discrete, max=nil)
  mod_keys = [mod_keys].flatten
  25.times do
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
        (-10..10).each do |v|
          unless min_or_discrete.include?(v)
            expect { org[key]=v }.to raise_error
          end
        end
      end
      
      
      range = org.range_for(key)
      
      if(max)
        range[:min].should == min_or_discrete
        range[:max].should == max
        range[:discrete].should == nil
      else
        range[:min].should == nil
        range[:max].should == nil
        range[:discrete].should == min_or_discrete
      end
    end
  end
end
