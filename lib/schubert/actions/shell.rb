require "schubert/action"

module Schubert::Actions
  class Shell < Schubert::Action
    def run(cmd)
      @system.run cmd
    end
  end
end
