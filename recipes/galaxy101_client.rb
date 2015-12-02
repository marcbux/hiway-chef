# prepare the galaxy 101 workflow file
template "#{node[:saasfee][:workflows]}/#{node[:saasfee][:galaxy101][:workflow]}" do
  user node[:saasfee][:user]
  group node[:hadoop][:group]
  source "#{node[:saasfee][:galaxy101][:workflow]}.erb"
  mode "755"
end

# prepare the Exons input file
cookbook_file "#{Chef::Config[:file_cache_path]}/#{node[:saasfee][:galaxy101][:exons][:targz]}" do
  source "#{node[:saasfee][:galaxy101][:exons][:targz]}"
  owner node[:saasfee][:user]
  group node[:hadoop][:group]
  mode "775"
  action :create_if_missing
end

# prepare the SNPs input file
cookbook_file "#{Chef::Config[:file_cache_path]}/#{node[:saasfee][:galaxy101][:snps][:targz]}" do
  source "#{node[:saasfee][:galaxy101][:snps][:targz]}"
  owner node[:saasfee][:user]
  group node[:hadoop][:group]
  mode "775"
  action :create_if_missing
end

# copy input data into hdfs
bash "stage_out_input_data" do
  user node[:saasfee][:user]
  group node[:hadoop][:group]
  code <<-EOH
  set -e && set -o pipefail
    tar xzvf #{Chef::Config[:file_cache_path]}/#{node[:saasfee][:galaxy101][:exons][:targz]} -C #{node[:saasfee][:data]}
    tar xzvf #{Chef::Config[:file_cache_path]}/#{node[:saasfee][:galaxy101][:snps][:targz]} -C #{node[:saasfee][:data]}
    #{node[:hadoop][:home]}/bin/hdfs dfs -put #{node[:saasfee][:data]}/#{node[:saasfee][:galaxy101][:exons][:bed]} #{node[:saasfee][:hiway][:hdfs][:basedir]}/#{node[:saasfee][:galaxy101][:exons][:bed]}
    #{node[:hadoop][:home]}/bin/hdfs dfs -put #{node[:saasfee][:data]}/#{node[:saasfee][:galaxy101][:snps][:bed]} #{node[:saasfee][:hiway][:hdfs][:basedir]}/#{node[:saasfee][:galaxy101][:snps][:bed]}
    rm #{node[:saasfee][:data]}/#{node[:saasfee][:galaxy101][:exons][:bed]}
    rm #{node[:saasfee][:data]}/#{node[:saasfee][:galaxy101][:snps][:bed]}
  EOH
  not_if "#{node[:hadoop][:home]}/bin/hdfs dfs -test -e #{node[:saasfee][:hiway][:hdfs][:basedir]}#{node[:saasfee][:galaxy101][:snps][:bed]}"
end
