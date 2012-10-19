require 'schubert/rule'

module Schubert::Rules
  class Directory < Schubert::Rule
    def initialize(sys, dir)
      @system = sys
      @directory = dir
    end

    def up
      @system.mkdir @directory
    end

    def down
      @system.rmdir_if_empty @directory
    end

    def save_data
      {
        "type" => "directory",
        "directory" => @directory
      }
    end
  end
end
