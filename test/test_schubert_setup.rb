require "test/unit"
require "schubert/setup"

class TestSchubertSetup < Test::Unit::TestCase
  def setup
    @system = Schubert::StubSystem.new
    @setup = Schubert::Setup.new @system
  end

  def test_detect_config
    @system.files["/etc/schubert-config"] = nil
    assert_equal false, @setup.detect_config
  end

  def test_generate_config
    id = "AAAA"
    @system.next_id = id

    @setup.generate_config

    assert_equal [[:mkdir, "/etc/schubert-config"],
                  [:write, "/etc/schubert-config/id", "#{id}\n"],
                  [:write, "/etc/schubert-config/transaction-log", ""],
                  [:mkdir, "/etc/schubert-config/transactions"]
                 ], @system.commands
  end

  def test_detect_config_when_configured
    id = "AAAA"
    @system.next_id = id

    @setup.generate_config

    conf = @setup.detect_config

    assert_kind_of Schubert::Config, conf
    assert_equal id, conf.system_id
  end

  def test_configure_anew
    id = "AAAB"
    @system.next_id = id

    conf = @setup.configure

    assert_kind_of Schubert::Config, conf
    assert_equal id, conf.system_id
  end

  def test_configure_when_configured
    id = "AAAB"
    @system.next_id = id

    @setup.configure
    @system.next_id = "NO"
    conf = @setup.configure

    assert_kind_of Schubert::Config, conf
    assert_equal id, conf.system_id
  end

end
