Schubert.rules do |r|
  r.load "sets/user"
  r.include "sets/rvm-ready"

  r.add_user :name => "rubycentral"

  r.package "libxml2-dev"
  r.package "libxslt1-dev"
  r.package "libsasl2-dev"
  r.package "libpq-dev"

  r.package "memcached"

  r.directory "/u/apps/rubygems.org", :owner => "rubycentral"
  r.sync_dir "shared/config"
  r.add_postgress_access
  r.add_hosts_entries
end
