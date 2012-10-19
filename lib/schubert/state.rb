require 'yaml'

module Schubert
  class State
    def initialize(rules, up=[], down=[])
      @rules = rules
      @up = up
      @down = down
    end

    attr_reader :rules, :up, :down

    def execute(trans)
      ran_down = []
      ran_up = []

      begin
        down.each do |d|
          d.down
          ran_down << d
        end

        up.each do |u|
          u.up
          ran_up << u
        end
      rescue StandardError => e
        ran_up.reverse_each { |u| u.down }
        ran_down.reverse_each { |d| d.up }

        raise e
      else
        trans.add save_data
      end
    end

    def save_data
      {
        "rules" => @rules.map { |r| r.save_data },
        "up" => up.map { |r| @rules.index(r) },
        "down" => down.map { |d| @rules.index(d) }
      }
    end

    def save(path)
      File.open path, "w" do |f|
        f << save_data.to_yaml
      end
    end

    def self.load_from(path)
      data = YAML.load File.read(path)

      rules = data["rules"]

      data["up"].map! { |i| rules[i] }
      data["down"].map! { |i| rules[i] }

      data
    end
  end
end
