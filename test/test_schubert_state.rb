require 'test/unit'
require 'schubert/state'

class TestSchubertState < Test::Unit::TestCase
  def setup
    @system = Schubert::StubSystem.new
  end

  def test_execute
    r = Schubert::RuleSet.new @system
    r.package "nginx"

    r.calculate.execute

    assert_equal [[:run, "apt-get install -q --force-yes nginx"]],
                 @system.commands
  end

  class PoisonRule
    def up
      raise "error"
    end
  end

  def test_execute_rolls_back_on_error
    r = Schubert::RuleSet.new @system
    r.package "nginx"

    r.inject_rule PoisonRule.new

    r.calculate.execute

    assert_equal [[:run, "apt-get install -q --force-yes nginx"],
                  [:run, "apt-get autoremove -y nginx"]],
                 @system.commands
  end
end
