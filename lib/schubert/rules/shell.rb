require "schubert/rule"

module Schubert::Rules
  class Shell < Schubert::Rule
    def initialize(sys, cmd, down_cmd=nil)
      @system = sys
      @command = cmd
      @down_command = down_cmd
    end

    def save_data
      { "type" => "shell", "up" => @command, "down" => @down_command }
    end

    def up
      @system.run @command
    end

    def down
      @system.run @down_command if @down_command
    end
  end
end
