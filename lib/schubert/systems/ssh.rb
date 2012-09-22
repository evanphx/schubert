require "schubert/system"

module Schubert::Systems
  class SSH

    def initialize(user, host)
      @user = user
      @host = host
    end

    def sh(cmd, capture=false)
      puts "RUN: #{cmd}"

      if capture
        `#{cmd}`
      else
        system cmd
      end
    end

    def run(cmd, capture=false)
      sh "ssh #{@user}@#{@host} #{cmd}", capture
    end

    def scp(local, remote)
      sh "scp #{local} #{@user}@#{@host}:#{remote}"
    end

    def debian_release
      str = run "cat /etc/lsb-release", true

      vars = {}
      str.split("\n").each do |line|
        k, v = line.split("=")
        vars[k] = v
      end

      vars["DISTRIB_CODENAME"]
    end

    def mkdir(path)
      run "mkdir #{path}"
    end

    def write_file(path, contents)
      t = Tempfile.new "schubert"
      t << contents
      t.close

      scp t.path, path

      t.close!
    end

    def delete(path)
      run "rm #{path}"
    end

    def rmdir_if_empty(path)
      run "rmdir #{path} || true"
    end
  end
end
