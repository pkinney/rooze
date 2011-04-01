require "rspec"
require "ooze_process"

describe "Ooze Process" do
  it "should solve a binomial equation" do
    proc1 = Proc.new do |org|
      sum = 0
      exp_sum = 0
      (-5..5).each do |x|
        expected = 0.2*x**2 - 0.4*x + 0.7
        actual = org[:c]*x**2 + org[:b]*x + org[:a]
        sum += (expected-actual).abs
        exp_sum += expected.abs
      end
      1-sum/exp_sum
    end

    oo = Ooze.new()
    example = Organism.new(:a, :b, :c)
    example.set_min_max_range_for_all(-1, 1)
    example.set_fitness_function(proc1)
    oo.populate_from_single_organism(example, 500)

    until oo.best.fitness > 0.99
      oo.tick
      oo.tick_count.should < 1000
      # puts oo.best.modifiables.sort_by{|key| key.to_s }.reverse.collect { |key|  "#{key} => #{'%.3f' % oo.best[key]}"}.join(", ") + " => #{oo.best.fitness}"
    end
    
    oo.best[:a].should be_within(0.15).of(0.7)
    oo.best[:b].should be_within(0.15).of(-0.4)
    oo.best[:c].should be_within(0.15).of(0.3)
  end
  
  it "should solve the n-queens problem" do
    n = 8
    example = Organism.new((1..n).collect{|v| "queen#{v}".to_sym})
    example.set_discrete_range_for_all(1..n)
    example.set_fitness_function do |org|
      n = org.modifiables.size
      captures = 0
      (1..(n-1)).each do |v1|
        q1 = "queen#{v1}".to_sym
        ((v1+1)..n).each do |v2|
          q2 = "queen#{v2}".to_sym
          if org[q2]==org[q1] || (org[q1]-org[q2]).abs == (v1-v2).abs
            captures += 1
          end
        end
      end
      captures == 0 ? 1.0 : 1.0-(captures.to_f/(n*(n-1)/2).to_f)
    end
    
    oo = Ooze.new()
    oo.populate_from_single_organism(example, 1000)
    
    until oo.best.fitness==1.0
      oo.tick
      oo.tick_count.should < 1000
      # puts "%d - %.2f%%" % [oo.tick_count, oo.best.fitness*100]
    end
    
  end
end
