require "organism"
require "organism/sex"
require "organism/randomize"

class Ooze
  def initialize(initial_population = 0, *modifiables, &score_function)
    @organisms = []
    initial_population.times do
      @organisms << Organism.new(modifiables)
    end
    
    @score_proc = score_function
  end
  
  def population
    @organisms
  end
  
  def set_score_function(proc=nil, &block)
    @score_proc = proc || block
  end
  
  def get_score(org)
    raise "Score function not set" unless @score_proc
    @score_proc.call(org)
  end
  
  def get_best
    @organisms.max_by{|org| get_score(org)}
  end
end