require "test/unit"
require "schubert/actions/shell"
require "schubert/stub_system"

class TestSchubertActionShell < Test::Unit::TestCase
  def setup
    @system = Schubert::StubSystem.new
    @shell = Schubert::Actions::Shell.new @system
  end

  def test_run
    @shell.run "ls"
    assert_equal [[:run, "ls"]], @system.commands
  end
end
