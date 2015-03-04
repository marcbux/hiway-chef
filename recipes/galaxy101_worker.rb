# update tool shed
bash "update_tool_shed" do
  user node[:hiway][:user]
  group node[:hadoop][:group]
  environment "PYTHON_EGG_CACHE" => "#{node[:hiway][:home]}/.python-eggs"
  code <<-EOH
  set -e && set -o pipefail
    #{node[:hiway][:galaxy][:home]}/scripts/api/install_tool_shed_repositories.py --url http://toolshed.g2.bx.psu.edu/ --api `cat #{node[:hiway][:galaxy][:home]}/api` --local http://localhost:8080/ --name #{node[:hiway][:galaxy101][:join][:name]} --owner devteam --revision #{node[:hiway][:galaxy101][:join][:revision]} --repository-deps --tool-deps --panel-section-name galaxy101
  EOH
  not_if { ::File.exists?( "#{node[:hiway][:software][:dir]}/shed_tools/toolshed.g2.bx.psu.edu/repos/devteam/#{node[:hiway][:galaxy101][:join][:name]}" ) }
end
