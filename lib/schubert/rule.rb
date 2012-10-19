module Schubert
  module Rules
  end

  class Rule
    def hash
      save_data.hash
    end

    def ==(o)
      return false unless o.kind_of?(self.class)
      save_data == o.save_data
    end

    def eql?(o)
      self == o
    end
  end
end
