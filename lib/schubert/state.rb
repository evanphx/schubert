module Schubert
  class State
    def initialize(rules, up=[], down=[])
      @rules = rules
      @up = up
      @down = down
    end

    attr_reader :rules, :up, :down

    def execute
      down.each { |d| d.down }
      up.each { |u| u.up }
    end
  end
end
