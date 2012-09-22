require "test/unit"
require "schubert/rules/shell"
require "schubert/stub_system"

class TestSchubertRulesShell< Test::Unit::TestCase
  def setup
    @system = Schubert::StubSystem.new
    @shl = Schubert::Rules::Shell.new @system, "ls"
  end

  def test_up
    @shl.up

    assert_equal [[:run, "ls"]], @system.commands
  end

  def test_down
    @shl.down

    assert_equal [], @system.commands
  end

  def test_down_with_command
    shl = Schubert::Rules::Shell.new @system, "ls", "rm /tmp/blah"

    shl.down

    assert_equal [[:run, "rm /tmp/blah"]], @system.commands
  end

end

