node.default['java']['jdk_version'] = 7
node.default['java']['install_flavor'] = "openjdk"
include_recipe "java"


group node[:hiway][:group] do
end

user node[:hiway][:user] do
  comment 'Hiway user'
  gid node['hiway']['group']
  home node['hiway']['home']
  shell '/bin/bash'
  system true
  not_if "getent passwd #{node[:hiway][:user]}"
end

zippedFile = "#{Chef::Config[:file_cache_path]}/#{node[:hiway][:targz]}"
remote_file zippedFile do
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
  tar xfz #{zippedFile} -C #{node[:hiway][:dir]}
  EOF
  not_if { ::File.directory?("#{node[:hiway][:home]}") }
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
