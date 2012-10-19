Schubert.template "add_user" do |r,opt|
  up = "useradd -m -U #{opt[:name]}"
  down "userdel -r #{opt[:name]}"

  r.shell up, down
end
