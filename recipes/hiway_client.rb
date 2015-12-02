# create user hiway
user node[:saasfee][:user] do
  password "$1$salt$N3yBrMPqdSW4WoCjoBJMm."
  supports :manage_home => true
  home "#{node[:saasfee][:home]}"
  action :create
  shell '/bin/bash'
  system true
  not_if "getent passwd #{node[:saasfee][:user]}"
end

# add user hiway to group hadoop
group node[:hadoop][:group] do
  action :modify
  members node[:saasfee][:user] 
  append true
end

# create home directory
directory "#{node[:saasfee][:home]}" do
  owner node[:saasfee][:user]
  group node[:hadoop][:group]
  mode "755"
  recursive true
  action :create
  not_if { File.directory?("#{node[:saasfee][:home]}") }
end

# create workflows directory
directory "#{node[:saasfee][:workflows]}" do
  owner node[:saasfee][:user]
  group node[:hadoop][:group]
  mode "755"
  recursive true
  action :create
  not_if { File.directory?("#{node[:saasfee][:workflows]}") }
end

# create data directory
directory "#{node[:saasfee][:data]}" do
  owner node[:saasfee][:user]
  group node[:hadoop][:group]
  mode "755"
  recursive true
  action :create
  not_if { File.directory?("#{node[:saasfee][:data]}") }
end

# create software directory
directory node[:saasfee][:software][:dir] do
  owner node[:saasfee][:user]
  group node[:hadoop][:group]
  mode "0774"
  recursive true
  action :create
  not_if { File.directory?("#{node[:saasfee][:software][:dir]}") }
end

if node[:saasfee][:release] == "true"
  # download Hi-WAY binaries
  remote_file "#{Chef::Config[:file_cache_path]}/#{node[:saasfee][:hiway][:release][:targz]}" do
    source node[:saasfee][:hiway][:release][:url]
    owner node[:saasfee][:user]
    group node[:hadoop][:group]
    mode "775"
    action :create_if_missing
  end
  
  # install Hi-WAY binaries
  bash "install_hiway" do
    user node[:saasfee][:user]
    group node[:hadoop][:group]
    code <<-EOH
    set -e && set -o pipefail
      tar xvfz #{Chef::Config[:file_cache_path]}/#{node[:saasfee][:hiway][:release][:targz]} -C #{node[:saasfee][:software][:dir]}
    EOH
    not_if { ::File.exist?("#{node[:saasfee][:hiway][:home]}") }
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
    repository node[:saasfee][:hiway][:github_url]
    reference "master"
    user node[:saasfee][:user]
    group node[:hadoop][:group]
    action :sync
  end
  
  # maven build Hi-WAY
  bash 'build-hiway' do
    user node[:saasfee][:user]
    group node[:hadoop][:group]
    code <<-EOH
    set -e && set -o pipefail
      sed -i 's%<hadoop.version>[^<]*</hadoop.version>%<hadoop.version>#{node[:hadoop][:version]}</hadoop.version>%g' /tmp/hiway/hiway-core/pom.xml
      mvn -f /tmp/hiway/pom.xml package
      version=$(grep -Po '(?<=^\t<version>)[^<]*(?=</version>)' /tmp/hiway/pom.xml)
      cp -r /tmp/hiway/hiway-dist/target/hiway-dist-$version/hiway-$version #{node[:saasfee][:hiway][:home]}
      mv #{node[:saasfee][:hiway][:home]}/hiway-core-$version.jar #{node[:saasfee][:hiway][:home]}/hiway-core.jar
    EOH
    not_if { ::File.exist?("#{node[:saasfee][:hiway][:home]}") }
  end
end

# add script for running Hi-WAY
template "#{node[:saasfee][:hiway][:home]}/hiway" do 
  source "hiway.erb"
  owner node[:saasfee][:user]
  group node[:hadoop][:group]
  mode "755"
  action :create_if_missing
end

# add script for staging in workflow output data
template "#{node[:saasfee][:hiway][:home]}/stage" do 
  source "stage.erb"
  owner node[:saasfee][:user]
  group node[:hadoop][:group]
  mode "755"
  action :create_if_missing
end

# update Hadoop user environment for user hiway
hadoop_user_envs node[:saasfee][:user] do
  action :update
end

# add HIWAY_HOME environment variable
bash 'update_env_variables' do
  user node[:saasfee][:user]
  group node[:hadoop][:group]
  code <<-EOH
  set -e && set -o pipefail
    echo "export HIWAY_HOME=#{node[:saasfee][:hiway][:home]}" | tee -a #{node[:saasfee][:home]}/.bash*
  EOH
  not_if "grep -q HIWAY_HOME #{node[:saasfee][:home]}/.bash_profile"
end

# add hiway to /usr/bin
bash 'update_env_variables' do
  user "root"
  code <<-EOH
  set -e && set -o pipefail
    ln -f -s #{node[:saasfee][:hiway][:home]}/hiway /usr/bin/
    ln -f -s #{node[:saasfee][:hiway][:home]}/stage /usr/bin/
  EOH
  not_if { ::File.exist?("/usr/bin/hiway") }
end

# copy Hi-WAY conf file to Hadoop conf dir
template "#{node[:hadoop][:conf_dir]}/hiway-site.xml" do
  user node[:saasfee][:user]
  group node[:hadoop][:group]
  source "hiway-site.xml.erb"
  mode "0755"
end

# add the Hi-WAY jars to Hadoop classpath
bash "configure_hadoop_for_hiway" do
  user node[:saasfee][:user]
  group node[:hadoop][:group]
  code <<-EOH
  set -e && set -o pipefail
    if grep -q "yarn.application.classpath" #{node[:hadoop][:home]}/etc/hadoop/yarn-site.xml
    then
      perl -i -0pe 's%<name>yarn.application.classpath</name>\\s*<value>%<name>yarn.application.classpath</name>\\n\\t\\t<value>#{node[:saasfee][:hiway][:home]}/\\*, #{node[:saasfee][:hiway][:home]}/lib/\\*, %' #{node[:hadoop][:home]}/etc/hadoop/yarn-site.xml
    else
      sed -i 's%</configuration>%<property><name>yarn.application.classpath</name><value>#{node[:saasfee][:hiway][:home]}/*, #{node[:saasfee][:hiway][:home]}/lib/*, #{node[:hadoop][:yarn][:app_classpath]}</value></property></configuration>%' #{node[:hadoop][:home]}/etc/hadoop/yarn-site.xml
    fi
  EOH
  not_if "grep -q yarn.application.classpath #{node[:hadoop][:home]}/etc/hadoop/yarn-site.xml && grep -q #{node[:saasfee][:hiway][:home]} #{node[:hadoop][:home]}/etc/hadoop/yarn-site.xml"
end

# restart YARN RM for changes to yarn-site to take effect
service "resourcemanager" do
  action :restart
end

# create hiway user directory in HDFS (if necessary) and grant read and write rights to all users in hadoop group such that both the yarn and hiway users can use the directory
hadoop_hdfs_directory "#{node[:saasfee][:hiway][:hdfs][:basedir]}" do
  action :create_as_superuser
  owner node[:saasfee][:user]
  group node[:saasfee][:group]
  mode "0775"
end
