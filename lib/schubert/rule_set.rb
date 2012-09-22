require "schubert/rules/package"

module Schubert
  class RuleSet
    def initialize(system)
      @system = system
      @rules = []
    end

    def package(name)
      @rules << Schubert::Rules::Package.new(@system, name)
    end

    class State
      def initialize(rules, up=[], down=[])
        @rules = rules
        @up = up
        @down = down
      end

      attr_reader :rules, :up, :down
    end

    def calculate(prev=nil)
      if prev
        up = @rules - prev.rules
        down = prev.rules - @rules

        State.new @rules, up, down
      else
        State.new @rules, @rules.dup, []
      end
    end
  end
end
