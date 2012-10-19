require "schubert/config"

module Schubert
  class Setup
    CONFIG_PATH = "/etc/schubert-config"
    ID_PATH = File.join CONFIG_PATH, "id"

    def initialize(system)
      @system = system
    end

    def detect_config
      ary = @system.list_files CONFIG_PATH
      return false if ary.empty?

      Config.new @system
    end

    def generate_config
      id = @system.random_id
      @system.mkdir CONFIG_PATH
      @system.write_file ID_PATH, "#{id}\n"
      @system.write_file File.join(CONFIG_PATH, "transaction-log"), ""
      @system.mkdir File.join(CONFIG_PATH, "transactions")
    end

    def configure
      conf = detect_config
      return conf if conf

      generate_config
      Config.new @system
    end
  end
end
