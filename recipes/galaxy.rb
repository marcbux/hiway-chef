# install required packages
case node[:platform_family]
  when "debian"
    # required for cloning galaxy form the repository
    package "mercurial" do
      options "--force-yes"
    end
    # required to interface with Galaxy via http requests
    package "curl" do
      options "--force-yes"
    end
    # required as a dependency for certain galaxy tools
    package "python-dev" do
      options "--force-yes"
    end
    # required by Hi-WAY to interpret galaxy tools
    package "python-cheetah" do
      options "--force-yes"
    end
end

bash "install_galaxy" do
  user node[:hiway][:user]
  group node[:hadoop][:group]
  code <<-EOF
  set -e && set -o pipefail
    hg clone #{node[:hiway][:galaxy][:repository]} #{node[:hiway][:galaxy][:home]}
    hg update stable #{node[:hiway][:galaxy][:home]}
    cp #{node[:hiway][:galaxy][:home]}/config/galaxy.ini.sample #{node[:hiway][:galaxy][:home]}/config/galaxy.ini
    sed -i 's/#master_api_key = changethis/master_api_key = #{node[:hiway][:galaxy][:master_api_key]}/g' #{node[:hiway][:galaxy][:home]}/config/galaxy.ini
    sed -i 's/#admin_users = None/admin_users = #{node[:hiway][:galaxy][:admin_users]}/g' #{node[:hiway][:galaxy][:home]}/config/galaxy.ini
    sed -i 's/#tool_dependency_dir = None/tool_dependency_dir = dependencies/g' #{node[:hiway][:galaxy][:home]}/config/galaxy.ini
  EOF
  not_if { ::File.exists?( "#{node[:hiway][:galaxy][:home]}" ) }
end

service "galaxy" do
  supports :restart => true
  start_command "sh #{node[:hiway][:galaxy][:home]}/run.sh --daemon"
  stop_command "sh #{node[:hiway][:galaxy][:home]}/run.sh --stop-daemon"
  action :start
end

#cp #{node[:hiway][:galaxy][:home]}/config/tool_conf.xml.sample #{node[:hiway][:galaxy][:home]}/config/tool_conf.xml
#cp #{node[:hiway][:galaxy][:home]}/config/shed_tool_conf.xml #{node[:hiway][:galaxy][:home]}/shed_tool_conf.xml   
#curl --data "username=hiway&password=reverse&email=hiway@hiway.com" http://localhost:8080/api/users?key=reverse | grep "id" | sed 's/[\",]//g' | sed 's/id: //' > #{node[:hiway][:galaxy][:home]}/id
#curl -X POST http://localhost:8080/api/users/$id/api_key?key=reverse | sed 's/\"//g' > #{node[:hiway][:galaxy][:home]}/api
