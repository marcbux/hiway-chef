# copy Hi-WAY conf file to Hadoop conf dir
template "#{node[:hadoop][:conf_dir]}/hiway-site.xml" do
  user node[:hiway][:user]
  group node[:hadoop][:group]
  source "hadoop.hiway-site.xml.erb"
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
      perl -i -0pe 's%<name>yarn.application.classpath</name>\\s*<value>%<name>yarn.application.classpath</name>\\n\\t\\t<value>#{node[:hiway][:home]}/\\*, #{node[:hiway][:home]}/lib/\\*, %' #{node[:hadoop][:home]}/etc/hadoop/yarn-site.xml
    else
      sed -i 's%</configuration>%\t<property>\n\t\t<name>yarn.application.classpath</name>\\n\\t\\t<value>\$HADOOP_CONF_DIR, \$HADOOP_COMMON_HOME/share/hadoop/common/\\*, \$HADOOP_COMMON_HOME/share/hadoop/common/lib/\\*, \$HADOOP_HDFS_HOME/share/hadoop/hdfs/\\*, \$HADOOP_HDFS_HOME/share/hadoop/hdfs/lib/\\*, \$HADOOP_YARN_HOME/share/hadoop/yarn/\\*, \$HADOOP_YARN_HOME/share/hadoop/yarn/lib/\\*, \$HIWAY_HOME/\\*, \$HIWAY_HOME/lib/\\*</value>\\n\\t</property>\\n</configuration>%' #{node[:hadoop][:home]}/etc/hadoop/yarn-site.xml
    fi
  EOH
  not_if "grep -q yarn.application.classpath #{node[:hadoop][:home]}/etc/hadoop/yarn-site.xml && grep -q #{node[:hiway][:home]} #{node[:hadoop][:home]}/etc/hadoop/yarn-site.xml"
end

# restart YARN RM for changes to yarn-site to take effect
service "resourcemanager" do
  action :restart
  only_if { File.exist?("/etc/init.d/resourcemanager") }
end

# restart YARN NM for changes to yarn-site to take effect
service "nodemanager" do
  action :restart
  only_if { File.exist?("/etc/init.d/nodemanager") }
end

# create hiway user directory in HDFS
#hadoop_hdfs_directory "#node{[:hiway][:hdfs][:basedir]}" do
#  action :create
#  owner node[:hiway][:user]
#  group node[:hiway][:group]
#  mode "0775"
#end
