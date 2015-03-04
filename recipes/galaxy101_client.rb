# prepare the galaxy 101 workflow file
template "#{node[:hiway][:home]}/#{node[:hiway][:galaxy101][:workflow]}" do
  user node[:hiway][:user]
  group node[:hadoop][:group]
  source "#{node[:hiway][:galaxy101][:workflow]}.erb"
  mode "755"
end

# prepare the Exons input file
template "#{node[:hiway][:home]}/#{node[:hiway][:galaxy101][:exons]}" do
  user node[:hiway][:user]
  group node[:hadoop][:group]
  source "#{node[:hiway][:galaxy101][:exons]}.erb"
  mode "755"
end

# prepare the SNPs input file
template "#{node[:hiway][:home]}/#{node[:hiway][:galaxy101][:snps]}" do
  user node[:hiway][:user]
  group node[:hadoop][:group]
  source "#{node[:hiway][:galaxy101][:snps]}.erb"
  mode "755"
end

# copy input data into hdfs
bash "stage_out_input_data" do
  user node[:hiway][:user]
  group node[:hadoop][:group]
  code <<-EOH
  set -e && set -o pipefail
    #{node[:hadoop][:home]}/bin/hdfs dfs -put #{node[:hiway][:home]}/#{node[:hiway][:galaxy101][:exons]} #{node[:hiway][:hiway][:hdfs][:basedir]}
    #{node[:hadoop][:home]}/bin/hdfs dfs -put #{node[:hiway][:home]}/#{node[:hiway][:galaxy101][:snps]} #{node[:hiway][:hiway][:hdfs][:basedir]}
    rm #{node[:hiway][:home]}/#{node[:hiway][:galaxy101][:exons]}
    rm #{node[:hiway][:home]}/#{node[:hiway][:galaxy101][:snps]}
  EOH
  not_if "#{node[:hadoop][:home]}/bin/hdfs dfs -test -e #{node[:hiway][:hiway][:hdfs][:basedir]}#{node[:hiway][:galaxy101][:snps]}"
end
