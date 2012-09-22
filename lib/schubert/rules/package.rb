require "schubert/rule"

module Schubert::Rules
  class Package < Schubert::Rule
    def initialize(sys, name)
      @system = sys
      @name = name

      @source = nil
    end

    def source(url, dir)
      @source = [url, dir]
    end

    def up
      apt = Schubert::Actions::Apt.new @system

      if @source
        apt.add_source(@name, *@source)
        apt.update_cache
      end

      apt.install @name
    end

    def down
      apt = Schubert::Actions::Apt.new @system
      apt.remove @name

      if @source
        apt.remove_source @name
        apt.update_cache
      end
    end
  end
end
