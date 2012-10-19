require "schubert/rules/package"
require "schubert/rules/shell"
require "schubert/state"

module Schubert
  class RuleSet
    def initialize(system)
      @system = system
      @rules = []
    end

    def inject_rule(rule)
      @rules << rule
    end

    def package(name)
      x = Schubert::Rules::Package.new(@system, name)
      @rules << x

      yield x if block_given?
      x
    end

    def shell(up, down=nil)
      x = Schubert::Rules::Shell.new @system, up, down
      @rules << x
      x
    end

    def directory(dir, opts=nil)
      x = Schubert::Rules::Directory.new @system, dir
      @rules << x

      if opts && (u = opts[:owner])
        @rules << Schubert::Rules::Shell.new(@system, "chown #{u} #{dir}")
      end

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
