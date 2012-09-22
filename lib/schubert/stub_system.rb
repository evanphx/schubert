module Schubert
  class StubSystem
    def initialize
      @commands = []
      @debian_release = "DESTROYER"
    end

    attr_reader :commands
    attr_accessor :debian_release

    def run(cmd)
      @commands << [:run, cmd]
    end

    def mkdir(path)
      @commands << [:mkdir, path]
    end

    def write_file(path, content)
      @commands << [:write, path, content]
    end

    def delete(path)
      @commands << [:delete, path]
    end

    def rmdir_if_empty(path)
      @commands << [:rmdir_if_empty, path]
    end
  end
end
