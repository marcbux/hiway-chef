node.default['java']['jdk_version'] = 7
node.default['java']['install_flavor'] = "openjdk"
include_recipe "java"

user node[:hiway][:user] do
  supports :manage_home => true
  action :create
  home "/home/#{node[:hiway][:user]}"
  system true
  shell "/bin/bash"
end

group node[:hiway][:group] do
  action :modify
  members ["#{node[:hiway][:user]}"]
  append true
end


remote_file "#{Chef::Config[:file_cache_path]}/#{node[:hiway][:targz]}" do
  source node[:hiway][:url]
  owner node[:hiway][:user]
  group node[:hiway][:group]
  mode "0775"
  action :create_if_missing
end


bash "install_hiway" do
  user node[:hiway][:user]
  group node[:hiway][:group]
  code <<-EOF
  set -e && set -o pipefail
  tar xfz #{Chef::Config[:file_cache_path]}/#{node[:hiway][:targz]} -C #{node[:hiway][:dir]}
  EOF
#    not_if { ::File.exists?("#{node[:hiway][:home]}") }
end

template "#{node[:hadoop][:conf_dir]}/hiway-site.xml" do
  user node[:hiway][:user]
  group node[:hiway][:group]
  source "install.hiway-site.xml.erb"
  mode "0755"
end

link "#{node[:hadoop][:dir]}/hiway" do
  to node[:hiway][:home]
end
