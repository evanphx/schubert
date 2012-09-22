module Schubert
  module Systems
  end

  class System
    @current = nil
    def self.current
      @current
    end

    def self.current=(c)
      @current = c
    end
  end
end
