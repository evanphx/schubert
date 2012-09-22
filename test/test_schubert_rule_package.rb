require "test/unit"
require "schubert/rules/package"
require "schubert/stub_system"

class TestSchubertRulesPackage < Test::Unit::TestCase
  def setup
    @system = Schubert::StubSystem.new
    @pkg = Schubert::Rules::Package.new @system, "nginx"
  end

  def test_up
    @pkg.up

    assert_equal [[:run, "apt-get install nginx"]], @system.commands
  end

  def test_down
    @pkg.down

    assert_equal [[:run, "apt-get remove nginx"]], @system.commands
  end

  def test_up_with_source
    @system.debian_release = "cute"

    pkg = Schubert::Rules::Package.new @system, "nginx"
    pkg.source "http://blah.com", "blah"

    pkg.up

    assert_equal [
      [:mkdir, "/etc/apt/sources.list.d"],
      [:write, "/etc/apt/sources.list.d/schubert-nginx",
               "deb http://blah.com cute blah\n"],
      [:run, "apt-get update"],
      [:run, "apt-get install nginx"]
    ], @system.commands
  end

  def test_down_with_source
    pkg = Schubert::Rules::Package.new @system, "nginx"
    pkg.source "http://blah.com", "blah"

    pkg.down

    assert_equal [
      [:run, "apt-get remove nginx"],
      [:delete, "/etc/apt/sources.list.d/schubert-nginx"],
      [:rmdir_if_empty, "/etc/apt/sources.list.d"],
      [:run, "apt-get update"],
    ], @system.commands
  end
end
