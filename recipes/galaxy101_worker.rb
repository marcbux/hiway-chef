# update tool shed: install join
bash "intall_join" do
  user node[:saasfee][:user]
  group node[:hadoop][:group]
  environment "PYTHON_EGG_CACHE" => "#{node[:saasfee][:home]}/.python-eggs"
  code <<-EOH
  set -e && set -o pipefail
    #{node[:saasfee][:galaxy][:home]}/scripts/api/install_tool_shed_repositories.py --url http://toolshed.g2.bx.psu.edu/ --api `cat #{node[:saasfee][:galaxy][:home]}/api` --local http://localhost:8080/ --name #{node[:saasfee][:galaxy101][:join][:name]} --owner devteam --revision #{node[:saasfee][:galaxy101][:join][:revision]} --repository-deps --tool-deps --panel-section-name galaxy101
  EOH
  not_if { ::File.exists?( "#{node[:saasfee][:software][:dir]}/shed_tools/toolshed.g2.bx.psu.edu/repos/devteam/#{node[:saasfee][:galaxy101][:join][:name]}" ) }
end
