require "test/unit"

require "schubert/transactions"

class TestSchubertTransactions < Test::Unit::TestCase
  def setup
    @system = Schubert::StubSystem.new
    @trans = Schubert::Transactions.new @system
  end

  def test_list
    assert_equal 0, @trans.list.size
  end

  def test_add
    data = { "blah" => "true" }

    t = @trans.add data

    id = t.id

    path = "/etc/schubert-config/transactions/#{id}"

    assert_equal [[:write, path, t.raw_data],
                  [:append, "/etc/schubert-config/transaction-log", "#{t.id}\n"],
                  [:write, "/etc/schubert-config/state", "#{t.id}\n"]

                 ], @system.commands
  end

  def test_list_with_transactions
    assert_equal 0, @trans.list.size

    data = { "blah" => "true" }
    @trans.add data

    ary = @trans.list
    assert_equal 1, ary.size
    assert_equal data, ary.first.user_data
  end

  def test_latest
    data = { "blah" => "true" }
    t = @trans.add data

    latest = @trans.latest
    assert_equal t.id, latest.id

    assert_equal [:read, "/etc/schubert-config/state"],
                 @system.commands[-2]
  end

end
