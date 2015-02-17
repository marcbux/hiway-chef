# prepare the word count workflow file
template "#{node[:hiway][:home]}/#{node[:hiway][:wordcount][:workflow]}" do
  user node[:hiway][:user]
  group node[:hadoop][:group]
  source "#{node[:hiway][:wordcount][:workflow]}.erb"
  mode "0774"
end

# obtain the word count input file
remote_file "#{Chef::Config[:file_cache_path]}/#{node[:hiway][:wordcount][:input][:zip]}" do
  source node[:hiway][:wordcount][:input][:url]
  owner node[:hiway][:user]
  group node[:hadoop][:group]
  mode "0774"
  action :create_if_missing
end

# extract the input file and put it into hdfs
bash "extract_input_data" do
  user node[:hiway][:user]
  group node[:hadoop][:group]
  code <<-EOF
  set -e && set -o pipefail
    zcat #{Chef::Config[:file_cache_path]}/#{node[:hiway][:wordcount][:input][:zip]} > #{node[:hiway][:home]}/#{node[:hiway][:wordcount][:input][:txt]}
    #{node[:hadoop][:home]}/bin/hdfs dfs -put #{node[:hiway][:home]}/#{node[:hiway][:wordcount][:input][:txt]} #{node[:hiway][:hdfs][:basedir]}#{node[:hiway][:wordcount][:input][:txt]}
  EOF
  not_if "#{node[:hadoop][:home]}/bin/hdfs dfs -test -e #{node[:hiway][:hdfs][:basedir]}#{node[:hiway][:wordcount][:input][:txt]}"
end
