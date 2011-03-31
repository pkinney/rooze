require "ooze"

class Ooze
  def tick
    @organisms = @organisms.sort_by{|org| get_score(org)}.reverse
    start_size = @organisms.size
    @organisms = @organisms[0...(start_size/3)]
    new_orgs = []
    @organisms.each { |org| new_orgs << org.mate_with(@organisms[rand(@organisms.size)]) }
    @organisms << new_orgs
    @organisms.flatten!
    until @organisms.size >= start_size
      @organisms << @organisms[rand(@organisms.size)].mutate_to_child
    end
    get_best
  end
end