require "organism"
require "ooze"

class Ooze
  def tick
    @organisms = @organisms.sort_by{|org| get_score(org)}.reverse
    start_size = @organisms.size
    @organisms = @organisms[0...(start_size/3)]
    new_orgs = []
    @organisms.each { |org| new_orgs << org.mate_with(@organisms[rand(@organisms.size)]) }
    @organisms << new_orgs
    @organisms.flatten!
    until @organisms.size >= start_size
      @organisms << @organisms[rand(@organisms.size)].mutate_to_child
    end
    get_score(get_best)
  end
end

proc = Proc.new do |org|
  sum = 0
  (-5..5).each do |x|
    expected = 0.15*x**3 + 0.2*x**2 + 0.4*x + 1
    actual = org[:d]*x**3 +org[:c]*x**2 + org[:b]*x + org[:a]
    sum -= (expected-actual).abs
  end
  sum
end

oo = Ooze.new(1000, :a, :b, :c, :d)
oo.set_score_function(proc)
oo.randomize_all

100.times do
  oo.tick
  best = oo.get_best
  print best.modifiables.sort_by{|key| key.to_s }.reverse.collect { |key|  "#{key} => #{'%.3f' % best[key]}"}.join(", ")
  puts " => #{oo.get_score(best)}"
end
