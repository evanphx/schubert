require 'test/unit'
require 'schubert/state'
require 'schubert/transactions'
require 'tempfile'

class TestSchubertState < Test::Unit::TestCase
  def setup
    @system = Schubert::StubSystem.new
    @trans = Schubert::Transactions.new @system
  end

  def test_execute
    r = Schubert::RuleSet.new @system
    r.package "nginx"

    r.calculate.execute @trans

    assert_equal [:run, "apt-get install -q --force-yes nginx"],
                 @system.commands.first
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

    assert_raises RuntimeError do
      r.calculate.execute @trans
    end

    assert_equal [[:run, "apt-get install -q --force-yes nginx"],
                  [:run, "apt-get autoremove -y nginx"]],
                 @system.commands
  end

  def test_save_data
    r = Schubert::RuleSet.new @system
    r.package "nginx"

    s = r.calculate.save_data

    a = s["rules"].first

    assert_equal a["type"], "package"
    assert_equal a["name"], "nginx"

    assert_equal 0, s["up"].first
  end

  def test_load_from
    r = Schubert::RuleSet.new @system
    r.package "nginx"

    t = Tempfile.new "schubert"
    t.close

    r.calculate.save t.path

    s = Schubert::State.load_from t.path
    a = s["rules"].first

    assert_equal a["type"], "package"
    assert_equal a["name"], "nginx"

    assert_equal a, s["up"].first
  end
end
