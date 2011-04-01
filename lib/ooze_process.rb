require "ooze"

class Ooze
  def tick
    @tick_count ||= 0
    @tick_count += 1
    @organisms = @organisms.sort_by{|org| org.fitness}.reverse
    start_size = @organisms.size
    carry_size = start_size/3
    @organisms = @organisms[0...carry_size]
    @organisms = [@organisms, @organisms.collect { |org| org.mate_with(@organisms[rand(carry_size)]) }].flatten
    until @organisms.size >= start_size
      @organisms << @organisms[rand(carry_size)].mutate_to_child
    end
    best
  end
  
  def tick_count
    @tick_count ||= 0
  end
end