require "schubert/rules/package"
require "schubert/state"

module Schubert
  class RuleSet
    def initialize(system)
      @system = system
      @rules = []
    end

    def package(name)
      x = Schubert::Rules::Package.new(@system, name)
      @rules << x

      yield x if block_given?
      x
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

  def self.rules
    r = RuleSet.new System.current
    yield r
    r
  end
end
