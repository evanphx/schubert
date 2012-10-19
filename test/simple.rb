Schubert.rules do |r|
  r.shell "touch /etc/schubert-test", "rm /etc/schubert-test"

  # r.package "nginx" do |x|
    # x.source "http://nginx.org/packages/ubuntu/", "nginx"
  # end
end
