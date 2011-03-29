class Organism
  
  def initialize(*mod_keys)
    @mods = {}
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
  
  def randomize_all(min = 0, max = 1)
    @mods.each_key {|mod_key| randomize(mod_key, min, max)}
  end
  
  def randomize(mod_key, min = 0, max = 1)
    self[mod_key] = rand*(max-min)+min
  end
  
  def mate_with(other)
    raise "Cannot mate with organism constructed with different modifiables" unless compatible_with? other
    kid = Organism.new(self.modifiables)
    modifiables.each{|key| kid[key] = (rand(2) == 0 ? self[key] : other[key]) }
    # puts self.modifiables.collect { |key|  "#{key} => #{self[key]}"}.join(", ")
    # puts other.modifiables.collect { |key|  "#{key} => #{other[key]}"}.join(", ")
    # puts kid.modifiables.collect { |key|  "#{key} => #{kid[key]}"}.join(", ")
    # puts
    kid
  end
		
	def mutate_to_child(chance=modifiables.size)
	  kid = Organism.new(self.modifiables)
    modifiables.each do |key|
      kid[key] = self[key] + (rand(chance)==0 ? (rand-0.5)*0.1 : 0)
    end
    kid
  end
end