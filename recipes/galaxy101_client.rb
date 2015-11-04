# prepare the galaxy 101 workflow file
template "#{node[:hiway][:data]}/#{node[:hiway][:galaxy101][:workflow]}" do
  user node[:hiway][:user]
  group node[:hadoop][:group]
  source "#{node[:hiway][:galaxy101][:workflow]}.erb"
  mode "755"
end

# prepare the Exons input file
cookbook_file "#{Chef::Config[:file_cache_path]}/#{node[:hiway][:galaxy101][:exons][:targz]}" do
  source "#{node[:hiway][:galaxy101][:exons][:targz]}"
  owner node[:hiway][:user]
  group node[:hadoop][:group]
  mode "775"
  action :create_if_missing
end

# prepare the SNPs input file
cookbook_file "#{Chef::Config[:file_cache_path]}/#{node[:hiway][:galaxy101][:snps][:targz]}" do
  source "#{node[:hiway][:galaxy101][:snps][:targz]}"
  owner node[:hiway][:user]
  group node[:hadoop][:group]
  mode "775"
  action :create_if_missing
end

# untar input data
bash "untar_input_data" do
  user node[:hiway][:user]
  group node[:hadoop][:group]
  code <<-EOH
  set -e && set -o pipefail
    tar xzvf #{Chef::Config[:file_cache_path]}/#{node[:hiway][:galaxy101][:exons][:targz]} -C #{node[:hiway][:data]}
    tar xzvf #{Chef::Config[:file_cache_path]}/#{node[:hiway][:galaxy101][:snps][:targz]} -C #{node[:hiway][:data]}
  EOH
  only_if { ::File.exists?( "#{Chef::Config[:file_cache_path]}/#{node[:hiway][:galaxy101][:exons][:targz]}" ) }
end

hadoop_hdfs_directory "#{node[:hiway][:data]}/#{node[:hiway][:galaxy101][:exons][:bed]}" do
  action :put
  dest "#{node[:hiway][:hiway][:hdfs][:basedir]}"
  owner node[:hiway][:user]
  group node[:hiway][:group]
  mode "0775"
end

hadoop_hdfs_directory "#{node[:hiway][:data]}/#{node[:hiway][:galaxy101][:snps][:bed]}" do
  action :put
  dest "#{node[:hiway][:hiway][:hdfs][:basedir]}"
  owner node[:hiway][:user]
  group node[:hiway][:group]
  mode "0775"
end

# copy input data into hdfs
bash "rm_local_input_data" do
  user node[:hiway][:user]
  group node[:hadoop][:group]
  code <<-EOH
  set -e && set -o pipefail
    rm #{node[:hiway][:data]}/#{node[:hiway][:galaxy101][:exons][:bed]}
    rm #{node[:hiway][:data]}/#{node[:hiway][:galaxy101][:snps][:bed]}
  EOH
  only_if { ::File.exists?( "#{node[:hiway][:data]}/#{node[:hiway][:galaxy101][:exons][:bed]}" ) }
end
