module Schubert
  class StubSystem
    def initialize
      @commands = []
      @debian_release = "DESTROYER"

      @files = {}
      @next_id = nil
    end

    attr_reader :commands, :files
    attr_accessor :debian_release, :next_id

    def run(cmd)
      @commands << [:run, cmd]
    end

    def mkdir(path)
      @commands << [:mkdir, path]
    end

    def write_file(path, content)
      @commands << [:write, path, content]
      @files[path] = content
    end

    def append_file(path, contents)
      @commands << [:append, path, contents]
      str = (@files[path] ||= "")
      str << contents
    end

    def read_file(path)
      @commands << [:read, path]
      @files[path]
    end

    def delete(path)
      @commands << [:delete, path]
    end

    def rmdir_if_empty(path)
      @commands << [:rmdir_if_empty, path]
    end

    def list_files(dir)
      @files.to_a.find_all { |k,v| v && k.index(dir) == 0 }.map { |a,b| a }
    end

    def random_id
      @next_id
    end

    def read_last_line(path)
      @commands << [:read_last_line, path]
      @files[path].split("\n").last
    end
  end
end
