module Schubert
  class State
    def initialize(rules, up=[], down=[])
      @rules = rules
      @up = up
      @down = down
    end

    attr_reader :rules, :up, :down

    def execute
      ran_down = []
      ran_up = []

      begin
        down.each do |d|
          d.down
          ran_down << d
        end

        up.each do |u|
          u.up
          ran_up << u
        end
      rescue StandardError
        ran_up.reverse_each { |u| u.down }
        ran_down.reverse_each { |d| d.up }
      end
    end
  end
end
