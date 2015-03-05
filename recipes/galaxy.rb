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
    # required for downloading boto
    package "python-pip" do
      options "--force-yes"
    end
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
  user node[:hiway][:user]
  group node[:hadoop][:group]
  environment "PYTHON_EGG_CACHE" => "#{node[:hiway][:home]}/.python-eggs"
  code <<-EOH
  set -e && set -o pipefail
    hg clone #{node[:hiway][:galaxy][:repository]} #{node[:hiway][:galaxy][:home]}
    cd #{node[:hiway][:galaxy][:home]}
    hg update stable
    chmod -R 755 #{node[:hiway][:galaxy][:home]}
  EOH
  not_if { ::File.exists?( "#{node[:hiway][:galaxy][:home]}" ) }
end

# configure Galaxy
bash "configure_galaxy" do
  user node[:hiway][:user]
  group node[:hadoop][:group]
  code <<-EOH
  set -e && set -o pipefail
    cp #{node[:hiway][:galaxy][:home]}/config/galaxy.ini.sample #{node[:hiway][:galaxy][:home]}/config/galaxy.ini
    cp #{node[:hiway][:galaxy][:home]}/config/tool_conf.xml.main #{node[:hiway][:galaxy][:home]}/config/tool_conf.xml
    sed -i 's%#tool_config_file = config/tool_conf.xml,shed_tool_conf.xml%tool_config_file = config/tool_conf.xml,config/shed_tool_conf.xml%g' #{node[:hiway][:galaxy][:home]}/config/galaxy.ini
    sed -i 's/#host = 127.0.0.1/host = 0.0.0.0/g' #{node[:hiway][:galaxy][:home]}/config/galaxy.ini
    sed -i 's/#master_api_key = changethis/master_api_key = #{node[:hiway][:galaxy][:master_api_key]}/g' #{node[:hiway][:galaxy][:home]}/config/galaxy.ini
    sed -i 's/#admin_users = None/admin_users = #{node[:hiway][:galaxy][:admin_users]}/g' #{node[:hiway][:galaxy][:home]}/config/galaxy.ini
    sed -i 's/#tool_dependency_dir = None/tool_dependency_dir = dependencies/g' #{node[:hiway][:galaxy][:home]}/config/galaxy.ini
    sed -i 's%#shed_tool_data_table_config = config/shed_tool_data_table_conf.xml%shed_tool_data_table_config = config/shed_tool_data_table_conf.xml%g' #{node[:hiway][:galaxy][:home]}/config/galaxy.ini
  EOH
  not_if "grep -q \"tool_dependency_dir = dependencies\" #{node[:hiway][:galaxy][:home]}/config/galaxy.ini"
end

# startup Galaxy
bash "install_galaxy" do
  user node[:hiway][:user]
  group node[:hadoop][:group]
  environment "PYTHON_EGG_CACHE" => "#{node[:hiway][:home]}/.python-eggs"
  code <<-EOH
  set -e && set -o pipefail
    sh #{node[:hiway][:galaxy][:home]}/run.sh --daemon
    while ! grep -q "serving on" #{node[:hiway][:galaxy][:home]}/paster.log; do
      sleep 1
    done
  EOH
  not_if { ::File.exists?( "#{node[:hiway][:galaxy][:home]}/paster.pid" ) }
end

# sh #{node[:hiway][:galaxy][:home]}/run.sh --stop-daemon
# rm #{node[:hiway][:galaxy][:home]}/paster.log

# generate an API key
bash "generate_api_key" do
  user node[:hiway][:user]
  group node[:hadoop][:group]
  code <<-EOH
  set -e && set -o pipefail
    curl --data "username=#{node[:hiway][:user]}&password=#{node[:hiway][:galaxy][:master_api_key]}&email=#{node[:hiway][:galaxy][:admin_users]}" "http://localhost:8080/api/users?key=#{node[:hiway][:galaxy][:master_api_key]}" | grep "id" | sed 's/[\", ]//g' | sed 's/id://' > #{node[:hiway][:galaxy][:home]}/id
    curl -X POST http://localhost:8080/api/users/`cat #{node[:hiway][:galaxy][:home]}/id`/api_key?key=#{node[:hiway][:galaxy][:master_api_key]} | sed 's/\"//g' > #{node[:hiway][:galaxy][:home]}/api
  EOH
  not_if { ::File.exists?( "#{node[:hiway][:galaxy][:home]}/api" ) }
end
