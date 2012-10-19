require 'schubert/transaction'

module Schubert
  class Transactions
    LOG = "/etc/schubert-config/transaction-log"
    TRANSACTIONS = "/etc/schubert-config/transactions"
    STATE = "/etc/schubert-config/state"

    def initialize(sys)
      @system = sys
    end

    def list
      ary = @system.list_files("/etc/schubert-config/transactions")
      ary.map { |f| Transaction.load @system.read_file(f) }
    end

    def add(data)
      t = Transaction.create data
      @system.write_file "/etc/schubert-config/transactions/#{t.id}", t.raw_data
      @system.append_file LOG, "#{t.id}\n"
      @system.write_file "/etc/schubert-config/state", "#{t.id}\n"
      t
    end

    def latest
      id = @system.read_file(STATE).strip
      Transaction.load @system.read_file(File.join(TRANSACTIONS, id))
    end
  end
end
