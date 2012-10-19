require "schubert/system"
require "socket"

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
      tmp = "/tmp/#{$$}-#{Time.now.to_f}"
      sh "scp #{local} #{@user}@#{@host}:#{tmp}"
      run "mv #{tmp} #{remote}"
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

    def append_file(path, contents)
      t = Tempfile.new "schubert"
      t << contents
      t.close

      run "'cat >> #{path}' < #{t.path}"

      t.close!
    end

    def read_file(path)
      out = run "cat #{path}", true
      return nil if $?.exitstatus != 0
      out
    end

    def delete(path)
      run "rm #{path}"
    end

    def rmdir_if_empty(path)
      run "rmdir #{path} || true"
    end

    def list_files(dir)
      out = run("ls #{dir}", true)

      return [] if $?.exitstatus != 0

      out.split("\n")
    end

    def random_id
      Digest::SHA1.hexdigest "#{Time.now.to_f}#{Socket.gethostname}#{$$}"
    end
  end
end
