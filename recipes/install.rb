node.default['java']['jdk_version'] = 7
node.default['java']['install_flavor'] = "openjdk"

# install Java 1.7
include_recipe "java"

# create user hiway
user node[:hiway][:user] do
  password "$1$salt$N3yBrMPqdSW4WoCjoBJMm."
  supports :manage_home => true
  home "#{node[:hiway][:home]}"
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

if node[:hiway][:release] == "true"
  # download Hi-WAY binaries
  remote_file "#{Chef::Config[:file_cache_path]}/#{node[:hiway][:hiway][:release][:zip]}" do
    source node[:hiway][:hiway][:release][:url]
    owner node[:hiway][:user]
    group node[:hadoop][:group]
    mode "775"
    action :create_if_missing
  end
  
  # install Hi-WAY binaries
  bash "install_bowtie2" do
    user node[:hiway][:user]
    group node[:hadoop][:group]
    code <<-EOH
    set -e && set -o pipefail
      unzip #{Chef::Config[:file_cache_path]}/#{node[:hiway][:hiway][:release][:zip]} -d #{node[:hiway][:software][:dir]}
    EOH
    not_if { ::File.exist?("#{node[:hiway][:hiway][:home]}") }
  end
else
  # install Git
  include_recipe "git"
  
  # install Maven
  package "maven" do
    options "--force-yes"
  end
  
  # git clone Hi-WAY
  git "/tmp/hiway" do
    repository node[:hiway][:hiway][:github_url]
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
      cp -r /tmp/hiway/hiway-dist/target/hiway-dist-#{node[:hiway][:hiway][:snapshot][:version]}/hiway-#{node[:hiway][:hiway][:snapshot][:version]} #{node[:hiway][:hiway][:home]}
    EOH
    not_if { ::File.exist?("#{node[:hiway][:hiway][:home]}") }
  end
end

# add script for running Hi-WAY
template "#{node[:hiway][:hiway][:home]}/hiway" do 
  source "hiway.erb"
  owner node[:hiway][:user]
  group node[:hadoop][:group]
  mode "755"
  action :create_if_missing
end

# add script for staging in workflow output data
template "#{node[:hiway][:hiway][:home]}/stage" do 
  source "stage.erb"
  owner node[:hiway][:user]
  group node[:hadoop][:group]
  mode "755"
  action :create_if_missing
end

# update Hadoop user environment for user hiway
hadoop_user_envs node[:hiway][:user] do
  action :update
end

# add HIWAY_HOME environment variable
bash 'update_env_variables' do
  user node[:hiway][:user]
  group node[:hadoop][:group]
  code <<-EOH
  set -e && set -o pipefail
    echo "export HIWAY_HOME=#{node[:hiway][:hiway][:home]}" | tee -a #{node[:hiway][:home]}/.bash*
  EOH
  not_if "grep -q HIWAY_HOME #{node[:hiway][:home]}/.bash_profile"
end

# add hiway to /usr/bin
bash 'update_env_variables' do
  user "root"
  code <<-EOH
  set -e && set -o pipefail
    ln -f -s #{node[:hiway][:hiway][:home]}/hiway /usr/bin/
    ln -f -s #{node[:hiway][:hiway][:home]}/stage /usr/bin/
  EOH
  not_if { ::File.exist?("/usr/bin/hiway") }
end
