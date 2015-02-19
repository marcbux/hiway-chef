# update tool shed
bash "update_tool_shed" do
  user node[:hiway][:user]
  group node[:hadoop][:group]
  environment "PYTHON_EGG_CACHE" => "/home/#{node[:hiway][:user]}/.python-eggs"
  code <<-EOH
  set -e && set -o pipefail
    #{node[:hiway][:galaxy][:home]}/scripts/api/install_tool_shed_repositories.py --url http://toolshed.g2.bx.psu.edu/ --api `cat #{node[:hiway][:galaxy][:home]}/api` --local http://localhost:8080/ --name join --owner devteam --revision de21bdbb8d28 --repository-deps --tool-deps --panel-section-name galaxy101
  EOH
  not_if { ::File.exists?( "#{node[:hiway][:software][:dir]}/shed_tools/toolshed.g2.bx.psu.edu/repos/devteam/join" ) }
end

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
bash "extract_input_data" do
  user node[:hiway][:user]
  group node[:hadoop][:group]
  code <<-EOH
  set -e && set -o pipefail
    #{node[:hadoop][:home]}/bin/hdfs dfs -put #{node[:hiway][:home]}/#{node[:hiway][:galaxy101][:exons]} #{node[:hiway][:hdfs][:basedir]}
    #{node[:hadoop][:home]}/bin/hdfs dfs -put #{node[:hiway][:home]}/#{node[:hiway][:galaxy101][:snps]} #{node[:hiway][:hdfs][:basedir]}
  EOH
  not_if "#{node[:hadoop][:home]}/bin/hdfs dfs -test -e #{node[:hiway][:hdfs][:basedir]}#{node[:hiway][:galaxy101][:snps]}"
end
