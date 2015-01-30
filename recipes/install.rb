node.default['java']['jdk_version'] = 7
node.default['java']['install_flavor'] = "openjdk"
include_recipe "java"
include_recipe "git"

case node[:platform_family]
  when "debian"
    package "maven" do
      options "--force-yes"
    end

  when "rhel"
    protobuf_lib_prefix = "/" 
    ark "maven" do
      url "http://apache.mirrors.spacedump.net/maven/maven-3/#{node[:maven][:version]}/binaries/apache-maven-#{node[:maven][:version]}-bin.tar.gz"
      version "#{node[:maven][:version]}"
      path "/usr/local/maven/"
      home_dir "/usr/local/maven"
      append_env_path true
      owner "#{node[:hdfs][:user]}"
    end
end

user node[:hiway][:user] do
  supports :manage_home => true
  home "/home/#{node['hiway']['user']}"
  action :create
  shell '/bin/bash'
  system true
  not_if "getent passwd #{node[:hiway][:user]}"
end

group node[:hiway][:group] do
  action :modify
  members node[:hiway][:user] 
  append true
end

git "/tmp/hiway" do
  repository node[:hiway][:github_url]
  reference "master"
  user node[:hiway][:user]
  action :sync
end

bash 'build-hiway' do
  user node[:hiway][:user]
  code <<-EOH
    set -e
    mvn -f /tmp/hiway/pom.xml package
    cp -r /tmp/hiway/hiway-dist/target/hiway-dist-#{node[:hiway][:version]}/hiway-#{node[:hiway][:version]} #{node[:hiway][:home]}
  EOH
  not_if { ::File.exist?("#{node[:hiway][:home]}") }
end

link "#{node[:hadoop][:dir]}/hiway" do
  to node[:hiway][:home]
end
