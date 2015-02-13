node.default['java']['jdk_version'] = 7
node.default['java']['install_flavor'] = "openjdk"

# install Java 1.7 and git
include_recipe "java"
include_recipe "git"

# install Maven
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

# create user hiway
user node[:hiway][:user] do
  supports :manage_home => true
  home "/home/#{node[:hiway][:user]}"
  action :create
  shell '/bin/bash'
  system true
  not_if "getent passwd #{node[:hiway][:user]}"
end

# add user hiway to group hadoop
group node[:hadoop][:group] do
  action :modify
  members node[:hiway][:user] 
  append true
end

# git clone Hi-WAY
git "/tmp/hiway" do
  repository node[:hiway][:github_url]
  reference "master"
  user node[:hiway][:user]
  group node[:hadoop][:group]
  action :sync
end

# maven build Hi-WAY
bash 'build-hiway' do
  user node[:hiway][:user]
  group node[:hadoop][:group]
  code <<-EOH
  set -e && set -o pipefail
    mvn -f /tmp/hiway/pom.xml package
    cp -r /tmp/hiway/hiway-dist/target/hiway-dist-#{node[:hiway][:version]}/hiway-#{node[:hiway][:version]} #{node[:hiway][:home]}
  EOH
  not_if { ::File.exist?("#{node[:hiway][:home]}") }
end

# add symbolic link to Hi-WAY dir
link "#{node[:hadoop][:dir]}/hiway" do
  to node[:hiway][:home]
end

# update Hadoop user environment for user hiway
hadoop_user_envs node[:hiway][:user] do
  action :update
end

# add HIWAY_HOME environment variable and add it to PATH
bash 'update_env_variables' do
  user node[:hiway][:user]
  group node[:hadoop][:group]
  code <<-EOH
  set -e && set -o pipefail
    echo "export HIWAY_HOME=#{node[:hiway][:home]}" | tee -a /home/#{node[:hiway][:user]}/.bash*
    echo "export PATH=\\$HIWAY_HOME:\\$PATH" | tee -a /home/#{node[:hiway][:user]}/.bash*
  EOH
  not_if "grep -q HIWAY_HOME /home/#{node[:hiway][:user]}/.bash_profile"
end

# add script for running Hi-WAY
template "#{node[:hiway][:home]}/hiway" do 
  source "hiway.erb"
  owner node[:hiway][:user]
  group node[:hadoop][:group]
  mode "755"
  action :create_if_missing
end
