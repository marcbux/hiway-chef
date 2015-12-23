# obtain data from hdfs
bash "get_data_from_hdfs" do
  user node[:saasfee][:user]
  group node[:hadoop][:group]
  code <<-EOH
  set -e && set -o pipefail
    #{node[:hadoop][:home]}/bin/hdfs dfs -get #{node[:saasfee][:hiway][:hdfs][:basedir]}/hg19.tar.gz #{node[:saasfee][:data]}/hg19.tar.gz
    tar -zxvf #{node[:saasfee][:data]}/hg19.tar.gz -C #{node[:saasfee][:data]}
    rm #{node[:saasfee][:data]}/hg19.tar.gz
  EOH
  not_if { ::File.exist?("#{node[:saasfee][:variantcall][:scale][:data]}") }
end
