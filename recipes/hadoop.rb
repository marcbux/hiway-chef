bash "configure_hadoop_for_hiway" do
  user node[:hiway][:user]
  group node[:hiway][:group]
  code <<-EOF
  set -e && set -o pipefail
  if grep -q "yarn.application.classpath" #{node[:hadoop][:home]}/etc/hadoop/yarn-site.xml
  then
    perl -i -0pe 's%<name>yarn.application.classpath</name>\\s*<value>%<name>yarn.application.classpath</name>\\n\\t\\t<value>#{node[:hiway][:home]}/\\*, #{node[:hiway][:home]}/lib/\\*, %' #{node[:hadoop][:home]}/etc/hadoop/yarn-site.xml
  else
    sed -i 's%</configuration>%<name>yarn.application.classpath</name>\\n\\t\\t<value>\$HADOOP_CONF_DIR, \$HADOOP_COMMON_HOME/share/hadoop/common/\\*, \$HADOOP_COMMON_HOME/share/hadoop/common/lib/\\*, \$HADOOP_HDFS_HOME/share/hadoop/hdfs/\\*, \$HADOOP_HDFS_HOME/share/hadoop/hdfs/lib/\\*, \$HADOOP_YARN_HOME/share/hadoop/yarn/\\*, \$HADOOP_YARN_HOME/share/hadoop/yarn/lib/\\*, \$HIWAY_HOME/\\*, \$HIWAY_HOME/lib/\\*</value>\\n\\t</property>\\n</configuration>%' #{node[:hadoop][:home]}/etc/hadoop/yarn-site.xml
  fi
  EOF
#    only_if { "grep -q #{node[:hiway][:home]} #{node[:hadoop][:home]}/etc/hadoop/yarn-site.xml" }
end

service "resourcemanager" do
  action :restart
  only_if { File.exist?("/etc/init.d/resourcemanager") }
end

service "nodemanager" do
  action :restart
  only_if { File.exist?("/etc/init.d/nodemanager") }
end

bash "create_hdfs_user_dir" do
  user node[:hiway][:user]
  group node[:hiway][:group]
  code <<-EOF
  set -e && set -o pipefail
  #{node[:hadoop][:home]}/bin/hdfs dfs -mkdir -p /user/#{node[:hiway][:user]}
  EOF
  not_if { "#{node[:hadoop][:home]}/bin/hdfs dfs -test -d /user/#{node[:hiway][:user]}" }
end
