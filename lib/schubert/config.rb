module Schubert
  class Config
    def initialize(system)
      @system = system
    end

    def system_id
      @system_id ||= @system.read_file("/etc/schubert-config/id").strip
    end

    def hostname
      @hostname ||= @system.run("hostname", true).strip
    end

    def name
      "#{hostname}-#{system_id}"
    end
  end
end
