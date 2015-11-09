# prepare the word count workflow file
template "#{node[:hiway][:data]}/#{node[:hiway][:wordcount][:workflow]}" do
  user node[:hiway][:user]
  group node[:hadoop][:group]
  source "#{node[:hiway][:wordcount][:workflow]}.erb"
  mode "755"
end

# obtain the word count input file
remote_file "#{Chef::Config[:file_cache_path]}/#{node[:hiway][:wordcount][:input][:zip]}" do
  source node[:hiway][:wordcount][:input][:url]
  owner node[:hiway][:user]
  group node[:hadoop][:group]
  mode "755"
  action :create_if_missing
end

# extract the input file
bash "extract_input_data" do
  user node[:hiway][:user]
  group node[:hadoop][:group]
  code <<-EOF
  set -e && set -o pipefail
    zcat #{Chef::Config[:file_cache_path]}/#{node[:hiway][:wordcount][:input][:zip]} > #{node[:hiway][:data]}/#{node[:hiway][:wordcount][:input][:txt]}
    #{node[:hadoop][:home]}/bin/hdfs dfs -put #{node[:hiway][:data]}/#{node[:hiway][:wordcount][:input][:txt]} #{node[:hiway][:hiway][:hdfs][:basedir]}/#{node[:hiway][:wordcount][:input][:txt]}
  EOF
  not_if "#{node[:hadoop][:home]}/bin/hdfs dfs -test -e #{node[:hiway][:hiway][:hdfs][:basedir]}#{node[:hiway][:wordcount][:input][:txt]}"
end
