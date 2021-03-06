require "schubert/action"

module Schubert::Actions
  class Apt < Schubert::Action
    def install(name)
      @system.run "apt-get install -q --force-yes #{name}"
    end

    def update_cache
      @system.run "apt-get update"
    end

    def remove(name)
      @system.run "apt-get autoremove -y #{name}"
    end

    def add_source(name, url, dir)
      content = "deb #{url} #{@system.debian_release} #{dir}\n"

      @system.mkdir "/etc/apt/sources.list.d"
      @system.write_file "/etc/apt/sources.list.d/schubert-#{name}.list", content
    end

    def remove_source(name)
      @system.delete "/etc/apt/sources.list.d/schubert-#{name}.list"
      @system.rmdir_if_empty "/etc/apt/sources.list.d"
    end
  end
end
