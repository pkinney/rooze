require "organism"

class Ooze
  def initialize
    @organisms = []
  end
  
  def self.from_modifiables_and_fitness_funtion(initial_population, *modifiables, &score_function)
    ooze = Ooze.new
    org = Organism.new(modifiables)
    org.set_fitness_function(score_function)
    ooze.populate_from_single_organism(org, initial_population)
    ooze
  end
  
  def populate_from_single_organism(org, count)
    @organisms = [org]
    (count-1).times { @organisms << Organism.new_from_example_organism(org)}
  end
  
  def population
    @organisms
  end
  
  def set_fitness_function(proc=nil, &block)
    @organisms.each { |org| org.set_fitness_function(proc || block) }
  end
  
  def best
    @organisms.max_by{ |org| org.fitness }
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