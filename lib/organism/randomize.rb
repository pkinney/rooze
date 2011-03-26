require "organism"

class Organism
  def randomize_all(min = 0, max = 1)
    @mods.each_key {|mod_key| randomize(mod_key, min, max)}
  end
  
  def randomize(mod_key, min = 0, max = 1)
    self[mod_key] = rand*(max-min)+min
  end
end