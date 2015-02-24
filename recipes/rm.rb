# copy Hi-WAY conf file to Hadoop conf dir
template "#{node[:hadoop][:conf_dir]}/hiway-site.xml" do
  user node[:hiway][:user]
  group node[:hadoop][:group]
  source "hiway-site.xml.erb"
  mode "0755"
end

# add the Hi-WAY jars to Hadoop classpath
bash "configure_hadoop_for_hiway" do
  user node[:hiway][:user]
  group node[:hadoop][:group]
  code <<-EOH
  set -e && set -o pipefail
    if grep -q "yarn.application.classpath" #{node[:hadoop][:home]}/etc/hadoop/yarn-site.xml
    then
      perl -i -0pe 's%<name>yarn.application.classpath</name>\\s*<value>%<name>yarn.application.classpath</name>\\n\\t\\t<value>#{node[:hiway][:hiway][:home]}/\\*, #{node[:hiway][:hiway][:home]}/lib/\\*, %' #{node[:hadoop][:home]}/etc/hadoop/yarn-site.xml
    else
      sed -i 's%</configuration>%\t<property>\n\t\t<name>yarn.application.classpath</name>\\n\\t\\t<value>#{node[:hiway][:hiway][:home]}/\\*, #{node[:hiway][:hiway][:home]}/lib/\\*, #{node[:hadoop][:yarn][:app_classpath]}</value>\\n\\t</property>\\n</configuration>%' #{node[:hadoop][:home]}/etc/hadoop/yarn-site.xml
    fi
  EOH
  not_if "grep -q yarn.application.classpath #{node[:hadoop][:home]}/etc/hadoop/yarn-site.xml && grep -q #{node[:hiway][:hiway][:home]} #{node[:hadoop][:home]}/etc/hadoop/yarn-site.xml"
end

# restart YARN RM for changes to yarn-site to take effect
service "resourcemanager" do
  action :restart
  only_if { File.exist?("/etc/init.d/resourcemanager") }
end

# create hiway user directory in HDFS (if necessary) and grant read and write rights to all users in hadoop group such that both the yarn and hiway users can use the directory
hadoop_hdfs_directory "#{node[:hiway][:hiway][:hdfs][:basedir]}" do
  action :create
  owner node[:hiway][:user]
  group node[:hiway][:group]
  mode "0775"
end
