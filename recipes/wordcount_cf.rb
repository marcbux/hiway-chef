template "#{node[:hiway][:home]}/#{node[:hiway][:wordcount][:workflow]}" do
  user node[:hiway][:user]
  group node[:hiway][:group]
  source "#{node[:hiway][:wordcount][:workflow]}.erb"
  mode "0774"
end

remote_file "#{Chef::Config[:file_cache_path]}/#{node[:hiway][:wordcount][:input][:zip]}" do
  source node[:hiway][:wordcount][:input][:url]
  owner node[:hiway][:user]
  group node[:hiway][:group]
  mode "0774"
  action :create_if_missing
end

bash "prepare_wordcount" do
  user node[:hiway][:user]
  group node[:hiway][:group]
  code <<-EOF
  set -e && set -o pipefail
    zcat #{Chef::Config[:file_cache_path]}/#{node[:hiway][:wordcount][:input][:zip]} > #{node[:hiway][:home]}/#{node[:hiway][:wordcount][:input][:txt]}
    #{node[:hadoop][:home]}/bin/hdfs dfs -put #{node[:hiway][:home]}/#{node[:hiway][:wordcount][:input][:txt]}
  EOF
  not_if "#{node[:hadoop][:home]}/bin/hdfs dfs -test -e /user/#{node[:hiway][:user]}/#{node[:hiway][:wordcount][:input][:txt]}"
end

#bash "run_wordcount" do
#  user node[:hiway][:user]
#  group node[:hiway][:group]
#  code <<-EOF
#  set -e && set -o pipefail
#    #{node[:hadoop][:home]}/bin/yarn jar #{node[:hiway][:home]}/hiway-core-#{node[:hiway][:version]}.jar -w #{node[:hiway][:home]}/#{node[:hiway][:wordcount][:workflow]} -s #{node[:hiway][:home]}/wordcount_summary.json
#  EOF
#  not_if { ::File.exists?("#{node[:hiway][:home]}/wordcount_summary.json") }
#end
