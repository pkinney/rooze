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
  
  def set_modifiable(mod_key, value)
    self[mod_key] = value
  end
  
  def []=(mod_key, value)
    raise "No such modifiable.  Valid modifiables are #{@mods.keys.join ', '}." unless is_modifiable?(mod_key)
    @mods[mod_key] = value
  end
  
  def is_modifiable?(mod_key)
    @mods.keys.include? mod_key
  end
  
  def modifiables
    @mods.keys
  end
  
  def [](mod_key)
    raise "No such modifiable.  Valid modifiables are #{@mods.keys.join ', '}." unless is_modifiable?(mod_key)
    @mods[mod_key]
  end
  
  def ==(other)
    return false unless modifiables==other.modifiables
    modifiables.all?{|key| self[key]==other[key]}
  end
end