require "test/unit"
require "schubert/rules/directory"

class TestSchubertRulesDirectory < Test::Unit::TestCase
  def setup
    @system = Schubert::StubSystem.new
    @dir = "/u/apps/blah"
    @r = Schubert::Rules::Directory.new @system, @dir
  end

  def test_up
    @r.up

    assert_equal [[:mkdir, @dir]], @system.commands
  end

  def test_down
    @r.down

    assert_equal [[:rmdir_if_empty, @dir]], @system.commands
  end

  def test_save_data
    assert_equal "directory", @r.save_data["type"]
    assert_equal @dir, @r.save_data["directory"]
  end
end
