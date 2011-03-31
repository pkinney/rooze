require "rspec"
require "ooze_process"

describe "Ooze Process" do
  it "should solve a binomial equation" do
    proc1 = Proc.new do |org|
      sum = 0
      (-5..5).each do |x|
        expected = 0.2*x**2 - 0.4*x + 0.7
        actual = org[:c]*x**2 + org[:b]*x + org[:a]
        sum += (expected-actual).abs
      end
      -sum
    end

    oo = Ooze.new(100, :a, :b, :c)
    oo.set_score_function(proc1)
    oo.set_min_max_range_for_all(-1, 1)
    oo.randomize_all

    100.times do
      oo.tick
      best = oo.get_best
      print best.modifiables.sort_by{|key| key.to_s }.reverse.collect { |key|  "#{key} => #{'%.3f' % best[key]}"}.join(", ")
      puts " => #{oo.get_score(best)}"
    end
  end
end
