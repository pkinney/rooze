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
  
  def randomize_all()
    @organisms.each do |org|
      org.randomize_all()
    end
  end
  
  def randomize(*mod_keys)
    mod_keys = [mod_keys].flatten
    @organisms.each do |org|
      mod_keys.each do |key|
        org.randomize(key)
      end
    end
  end
  
  def set_min_max_range_for_all(m1, m2)
    @organisms.each do |org|
      org.set_min_max_range_for_all(m1, m2)
    end
  end
  
  def set_min_max_range(mod_key, m1, m2)
    @organisms.each do |org|
      org.set_min_max_range(mod_key, m1, m2)
    end
  end
  
  def set_discrete_range_for_all(*m) 
    @organisms.each do |org|
      org.set_discrete_range_for_all(*m)
    end
  end
  
  def set_discrete_range(mod_key, *m)
    @organisms.each do |org|
      org.set_discrete_range(mod_key, *m)
    end
  end
end