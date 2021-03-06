class Organism
  def initialize(*mod_keys)
    @mods = {}
    @ranges = {}
    mod_keys.flatten.each{|k| @mods[k] = 0}
    randomize_all
  end
  
  def self.new_from_example_organism(org)
    new_org = Organism.new(org.modifiables)
    new_org.copy_ranges_from(org)
    new_org.randomize_all
    new_org.set_fitness_function(org.fitness_function)
    new_org
  end
  
  def set_fitness_function(proc=nil, &block)
    @fitness_function = proc || block
  end
  
  def fitness_function
    @fitness_function
  end
  
  def fitness
    @fitness ||= @fitness_function.call(self)
  end

  def add_modifiable(mod_key, value=nil)
    unless @mods.keys.include? mod_key
      @mods[mod_key] = value || random_value_for(mod_key)
    end
  end

  def [](mod_key)
    raise "No such modifiable.  Valid modifiables are #{@mods.keys.join ', '}." unless is_modifiable?(mod_key)
    @mods[mod_key]
  end

  def []=(mod_key, value)
    raise "No such modifiable.  Valid modifiables are #{@mods.keys.join ', '}." unless is_modifiable?(mod_key)
    raise "Modifiable value out of range.  Valid range is #{range_string_for(mod_key)}." unless in_range_for?(mod_key, value)
    raise "Modifiable value must be a valid number. '#{value}' is not a valid value" unless value.is_a? Numeric
    @mods[mod_key] = value
    @fitness = nil
  end

  def set_modifiables(map)
    map.each_pair{|k,v| self[k]==v}
  end

  def is_modifiable?(mod_key)
    @mods.keys.include? mod_key
  end

  def modifiables
    @mods.keys
  end
  
  def compatible_with? (other)
    compatible_modifiables?(other) && compatible_ranges?(other)
  end

  def compatible_modifiables?(other)
    return false unless modifiables.size==other.modifiables.size
    (modifiables & other.modifiables).size==modifiables.size
  end
  
  def compatible_ranges?(other)
    modifiables.all? do |key|
      range1 = range_for(key)
      range2 = other.range_for(key)
      if range1[:min] && range1[:max] && range2[:min] && range2[:max]
        (range1[:min] == range2[:min]) && (range1[:max] && range2[:max])
      elsif range1[:discrete] && range2[:discrete] && range1[:discrete].size==range2[:discrete].size
        (range1[:discrete] & range2[:discrete]).size==range1[:discrete].size
      else
        false
      end
    end
  end

  def ==(other)
    return false unless compatible_with? other
    modifiables.all?{|key| self[key]==other[key]}
  end
  
  def copy_ranges_from(other)
    raise "Cannot copy ranges as modifiables are not compatible" unless compatible_modifiables?(other)
    @ranges = {}
    modifiables.each {|key| @ranges[key] = other.range_for(key)}
  end

  def set_min_max_range_for_all(m1, m2)
    modifiables.each {|key| set_min_max_range(key, m1, m2)}
  end

  def set_min_max_range(mod_key, m1, m2)
    raise "Min and Max values must be numeric." unless (m1.is_a?(Numeric) && m2.is_a?(Numeric))
    @ranges[mod_key] = {:min => [m1, m2].min, :max => [m1, m2].max}
    randomize(mod_key) unless in_range_for?(mod_key, self[mod_key])
  end

  def set_discrete_range_for_all(*m)
    modifiables.each {|key| set_discrete_range(key, *m)}
  end

  def set_discrete_range(mod_key, *m)
    m.flatten!
    raise "Discrete range must include at least one value" if m.empty?
    m = m[0].to_a if m[0].is_a? Range
    raise "Discrete range must consist of only numeric values" unless m.all?{|v| v.is_a? Numeric}
    @ranges[mod_key] = {:discrete => m}
    randomize(mod_key) unless in_range_for?(mod_key, self[mod_key])
  end

  def range_for(mod_key)
    @ranges[mod_key] || {:min => 0, :max => 1}
  end

  def range_string_for(mod_key)
    range = range_for(mod_key)
    if range[:min] && range[:max]
      "between #{range[:min]} and #{range[:max]}"
    elsif range[:discrete] && !range[:discrete].empty?
      "one of [#{range[:discrete].join(' ')}]"
    else
      raise "Invalid range set for modifiable '#{mod_key.to_s}'"
    end
  end

  def in_range_for?(mod_key, value)
    range = range_for(mod_key)
    if range[:min] && range[:max]
      return value >= range[:min] && value <= range[:max]
    elsif range[:discrete] && !range[:discrete].empty?
      return range[:discrete].include?(value)
    else
      raise "Invalid range set for modifiable '#{mod_key.to_s}'"
    end
  end

  def randomize_all()
    @mods.each_key {|mod_key| randomize(mod_key)}
  end

  def randomize(mod_key)
    self[mod_key] = random_value_for(mod_key)
  end

  def random_value_for(mod_key)
    range = range_for(mod_key)
    if range[:min] && range[:max]
      rand*(range[:max]-range[:min])+range[:min]
    elsif range[:discrete] && !range[:discrete].empty?
      range[:discrete][rand(range[:discrete].size)]
    else
      raise "Invalid range set for modifiable '#{mod_key.to_s}'"
    end
  end

  def mate_with(other)
    raise "Cannot mate with organism constructed with different modifiables or ranges" unless compatible_with? other
    kid = Organism.new_from_example_organism(self)
    modifiables.each{|key| kid[key] = (rand(2) == 0 ? self[key] : other[key]) }
    kid
  end

  def mutate_to_child(chance=modifiables.size)
    kid = Organism.new_from_example_organism(self)
    modifiables.each do |key|
      kid[key] = (rand(chance)==0 ? self[key] : random_value_for(key))
    end
    kid
  end
end
