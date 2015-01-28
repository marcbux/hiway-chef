node.default['java']['jdk_version'] = 7
node.default['java']['install_flavor'] = "openjdk"
include_recipe "java"

group node[:hiway][:group] do
end

user node[:hiway][:user] do
  supports :manage_home => true
  home "/home/#{node['hiway']['user']}"
  action :create
  shell '/bin/bash'
  system true
  not_if "getent passwd #{node[:hiway][:user]}"
end

directory node[:hiway][:dir] do
  owner node[:hiway][:user]
  group node[:hiway][:group]
  mode "0774"
  recursive true
  action :create
end

group node[:hiway][:group] do
  action :modify
  members node[:hiway][:user] 
  append true
end

bash 'build-hiway' do
  user node[:hiway][:user]
  code <<-EOH
    set -e
    git clone #{node[:hiway][:github_url]} /tmp
    mvn -f ~/tmp/hiway-#{node[:hiway][:version]}/pom.xml package
    cp -r ~/tmp/hiway-#{node[:hiway][:version]}/hiway-dist/target/hiway-dist-#{node[:hiway][:version]}/hiway-#{node[:hiway][:version]} #{node[:hiway][:home]}
  EOH
  not_if { ::File.exist?("#{node[:hiway][:home]}") }
end

link "#{node[:hadoop][:dir]}/hiway" do
  to node[:hiway][:home]
end
