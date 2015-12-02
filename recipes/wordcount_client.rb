# prepare the word count workflow file
template "#{node[:saasfee][:workflows]}/#{node[:saasfee][:wordcount][:workflow]}" do
  user node[:saasfee][:user]
  group node[:hadoop][:group]
  source "#{node[:saasfee][:wordcount][:workflow]}.erb"
  mode "755"
end

# obtain the word count input file
remote_file "#{Chef::Config[:file_cache_path]}/#{node[:saasfee][:wordcount][:input][:zip]}" do
  source node[:saasfee][:wordcount][:input][:url]
  owner node[:saasfee][:user]
  group node[:hadoop][:group]
  mode "755"
  action :create_if_missing
end

# extract the input file
bash "extract_input_data" do
  user node[:saasfee][:user]
  group node[:hadoop][:group]
  code <<-EOF
  set -e && set -o pipefail
    zcat #{Chef::Config[:file_cache_path]}/#{node[:saasfee][:wordcount][:input][:zip]} > #{node[:saasfee][:data]}/#{node[:saasfee][:wordcount][:input][:txt]}
    #{node[:hadoop][:home]}/bin/hdfs dfs -put #{node[:saasfee][:data]}/#{node[:saasfee][:wordcount][:input][:txt]} #{node[:saasfee][:hiway][:hdfs][:basedir]}/#{node[:saasfee][:wordcount][:input][:txt]}
  EOF
  not_if "#{node[:hadoop][:home]}/bin/hdfs dfs -test -e #{node[:saasfee][:hiway][:hdfs][:basedir]}#{node[:saasfee][:wordcount][:input][:txt]}"
end
