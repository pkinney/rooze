require "ooze"

class Ooze
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