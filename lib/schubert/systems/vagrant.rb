require "schubert/systems/ssh"
require "tempfile"

module Schubert::Systems
  class Vagrant < SSH
    def initialize(dir)
      @dir = File.expand_path dir

      @config = Tempfile.new "schubert"

      Dir.chdir @dir do
        @config << `vagrant ssh-config`
      end

      @config.close
    end

    def run(cmd, capture=false)
      sh "ssh -F #{@config.path} default sudo #{cmd}", capture
    end

    def scp(local, remote)
      tmp = "/tmp/#{$$}-#{Time.now.to_f}"
      sh "scp -F #{@config.path} #{local} default:#{tmp}"
      run "mv #{tmp} #{remote}"
    end
  end
end
