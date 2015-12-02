# install required packages
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
# required for downloading boto
package "python-pip" do
  options "--force-yes"
end

# install boto and bioblend, which are required for upgrading Galaxy
bash "install_bioblend" do
  user "root"
  code <<-EOH
  set -e && set -o pipefail
    pip install boto==2.9.7
    pip install bioblend
  EOH
  not_if "pip list | grep boto (2.9.7)"
end

# install Galaxy
bash "install_galaxy" do
  user node[:saasfee][:user]
  group node[:hadoop][:group]
  timeout 604800
  environment "PYTHON_EGG_CACHE" => "#{node[:saasfee][:home]}/.python-eggs"
  code <<-EOH
  set -e && set -o pipefail
    hg clone #{node[:saasfee][:galaxy][:repository]} #{node[:saasfee][:galaxy][:home]}
    cd #{node[:saasfee][:galaxy][:home]}
    hg update stable
    chmod -R 755 #{node[:saasfee][:galaxy][:home]}
  EOH
  not_if { ::File.exists?( "#{node[:saasfee][:galaxy][:home]}" ) }
end

# configure Galaxy
bash "configure_galaxy" do
  user node[:saasfee][:user]
  group node[:hadoop][:group]
  code <<-EOH
  set -e && set -o pipefail
    cp #{node[:saasfee][:galaxy][:home]}/config/galaxy.ini.sample #{node[:saasfee][:galaxy][:home]}/config/galaxy.ini
    cp #{node[:saasfee][:galaxy][:home]}/config/tool_conf.xml.main #{node[:saasfee][:galaxy][:home]}/config/tool_conf.xml
    sed -i 's%#tool_config_file = config/tool_conf.xml,config/shed_tool_conf.xml%tool_config_file = config/tool_conf.xml,config/shed_tool_conf.xml%g' #{node[:saasfee][:galaxy][:home]}/config/galaxy.ini
    sed -i 's/#host = 127.0.0.1/host = 0.0.0.0/g' #{node[:saasfee][:galaxy][:home]}/config/galaxy.ini
    sed -i 's/#master_api_key = changethis/master_api_key = #{node[:saasfee][:galaxy][:master_api_key]}/g' #{node[:saasfee][:galaxy][:home]}/config/galaxy.ini
    sed -i 's/#admin_users = None/admin_users = #{node[:saasfee][:galaxy][:user][:email]}/g' #{node[:saasfee][:galaxy][:home]}/config/galaxy.ini
    sed -i 's/#tool_dependency_dir = None/tool_dependency_dir = dependencies/g' #{node[:saasfee][:galaxy][:home]}/config/galaxy.ini
    sed -i 's%#shed_tool_data_table_config = config/shed_tool_data_table_conf.xml%shed_tool_data_table_config = config/shed_tool_data_table_conf.xml%g' #{node[:saasfee][:galaxy][:home]}/config/galaxy.ini
  EOH
  not_if "grep -q \"tool_dependency_dir = dependencies\" #{node[:saasfee][:galaxy][:home]}/config/galaxy.ini"
end

# startup Galaxy
bash "install_galaxy" do
  user node[:saasfee][:user]
  group node[:hadoop][:group]
  environment "PYTHON_EGG_CACHE" => "#{node[:saasfee][:home]}/.python-eggs"
  code <<-EOH
  set -e && set -o pipefail
    sh #{node[:saasfee][:galaxy][:home]}/run.sh --daemon
    while ! grep -q "serving on" #{node[:saasfee][:galaxy][:home]}/paster.log; do
      sleep 1
    done
  EOH
  not_if { ::File.exists?( "#{node[:saasfee][:galaxy][:home]}/paster.pid" ) }
end

# sh #{node[:saasfee][:galaxy][:home]}/run.sh --stop-daemon
# rm #{node[:saasfee][:galaxy][:home]}/paster.log

# generate an API key
bash "generate_api_key" do
  user node[:saasfee][:user]
  group node[:hadoop][:group]
  code <<-EOH
  set -e && set -o pipefail
    curl --data "username=#{node[:saasfee][:galaxy][:user][:name]}&password=#{node[:saasfee][:galaxy][:user][:password]}&email=#{node[:saasfee][:galaxy][:user][:email]}" "http://localhost:8080/api/users?key=#{node[:saasfee][:galaxy][:master_api_key]}" | grep "id" | sed 's/[\", ]//g' | sed 's/id://' > #{node[:saasfee][:galaxy][:home]}/id
    curl -X POST http://localhost:8080/api/users/`cat #{node[:saasfee][:galaxy][:home]}/id`/api_key?key=#{node[:saasfee][:galaxy][:master_api_key]} | sed 's/\"//g' > #{node[:saasfee][:galaxy][:home]}/api
  EOH
  not_if { ::File.exists?( "#{node[:saasfee][:galaxy][:home]}/api" ) }
end
