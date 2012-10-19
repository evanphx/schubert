require 'digest/sha1'

module Schubert
  class Transaction
    def self.create(user_data)
      data = 
        {
          "id" => "0",
          "time" => Time.now.utc.to_f,
          "data" => user_data
        }

      data["id"] = Digest::SHA1.hexdigest(data.to_yaml)

      raw_data = data.to_yaml

      Transaction.new raw_data, data
    end

    def self.load(raw_data)
      data = YAML.load raw_data

      Transaction.new raw_data, data
    end

    def initialize(raw_data, data)
      @raw_data = raw_data
      @data = data
      @id = data["id"]
      @user_data = data["data"]
    end

    attr_reader :id, :data, :raw_data, :user_data
  end
end
