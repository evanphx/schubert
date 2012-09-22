require "schubert/rule"
require "schubert/actions/apt"

module Schubert::Rules
  class Package < Schubert::Rule
    def initialize(sys, name)
      @system = sys
      @name = name

      @source = nil
    end

    def ==(pkg)
      return unless pkg.kind_of? Package
      @name == pkg.name && @source == pkg.specific_source
    end

    alias_method :eql?, :==

    def hash
      @name.hash ^ @source.hash
    end

    attr_reader :name

    def source(url, dir)
      @source = [url, dir]
    end

    def specific_source
      @source
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
