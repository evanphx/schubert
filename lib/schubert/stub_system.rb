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
  end
end
