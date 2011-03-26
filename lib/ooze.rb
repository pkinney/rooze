require "organism"

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
  
  def randomize_all(min=0, max=1)
    @organisms.each do |org|
      org.randomize_all(min, max)
    end
  end
  
  def randomize(mod_keys, min=0, max=1)
    mod_keys = [mod_keys].flatten
    @organisms.each do |org|
      mod_keys.each do |key|
        org.randomize(key, min, max)
      end
    end
  end
end