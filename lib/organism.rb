class Organism
  def initialize(*mod_keys)
    @mods = {}
    @ranges = {}
    mod_keys.flatten.each{|k| @mods[k] = 0}
    randomize_all
  end
  
  def add_modifiable(mod_key, value=0)
    unless @mods.keys.include? mod_key
      @mods[mod_key] = value
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
    return false unless modifiables.size==other.modifiables.size
    modifiables.all?{|key| other.modifiables.include? key}
  end
  
  def ==(other)
    return false unless compatible_with? other
    modifiables.all?{|key| self[key]==other[key]}
  end
  
  def set_min_max_range_for_all(m1, m2)
    modifiables.each {|key| set_min_max_range(key, m1, m2)}
  end
  
  def set_min_max_range(mod_key, m1, m2)
    raise "Min and Max values must be numeric." unless (m1.is_a?(Numeric) && m2.is_a?(Numeric))
    @ranges[mod_key] = {:min => [m1, m2].min, :max => [m1, m2].max}
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
    raise "Cannot mate with organism constructed with different modifiables" unless compatible_with? other
    kid = Organism.new(self.modifiables)
    modifiables.each{|key| kid[key] = (rand(2) == 0 ? self[key] : other[key]) }
    kid
  end
  
	def mutate_to_child(chance=modifiables.size)
	  kid = Organism.new(self.modifiables)
    modifiables.each do |key|
      kid[key] = (rand(chance)==0 ? self[key] : random_value_for(key))
    end
    kid
  end
end