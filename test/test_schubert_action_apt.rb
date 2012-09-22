require "test/unit"
require "schubert/actions/apt"
require "schubert/stub_system"

class TestSchubertActionApt < Test::Unit::TestCase
  def setup
    @system = Schubert::StubSystem.new
    @apt = Schubert::Actions::Apt.new @system
  end

  def test_install
    @apt.install "nginx"

    assert_equal [[:run, "apt-get install nginx"]], @system.commands
  end

  def test_update_cache
    @apt.update_cache

    assert_equal [[:run, "apt-get update"]], @system.commands
  end

  def test_remove
    @apt.remove "nginx"

    assert_equal [[:run, "apt-get remove nginx"]], @system.commands
  end

  def test_add_source
    @system.debian_release = "cute"
    @apt.add_source "blah", "http://blah.com", "blah"

    expected = "deb http://blah.com cute blah\n"

    c = @system.commands
    assert_equal [:mkdir, "/etc/apt/sources.list.d"], c[0]
    assert_equal [:write, 
                   "/etc/apt/sources.list.d/schubert-blah", expected], c[1]
  end

  def test_remove_source
    @apt.remove_source "blah"

    c = @system.commands

    assert_equal [:delete, "/etc/apt/sources.list.d/schubert-blah"], c[0]
    assert_equal [:rmdir_if_empty, "/etc/apt/sources.list.d"], c[1]
  end
end
