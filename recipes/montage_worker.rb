# download Montage binaries
remote_file "#{Chef::Config[:file_cache_path]}/#{node[:saasfee][:montage][:targz]}" do
  source node[:saasfee][:montage][:url]
  owner node[:saasfee][:user]
  group node[:hadoop][:group]
  mode "0775"
  action :create_if_missing
end

# install Montage
bash "install_montage" do
  user node[:saasfee][:user]
  group node[:hadoop][:group]
  code <<-EOH
  set -e && set -o pipefail
    tar xvfz #{Chef::Config[:file_cache_path]}/#{node[:saasfee][:montage][:targz]} -C #{node[:saasfee][:software][:dir]}
    make -C #{node[:saasfee][:montage][:home]}
  EOH
  not_if { ::File.exist?("#{node[:saasfee][:montage][:home]}/bin/mDAG") }
end

# add Montage executables to /usr/bin
bash 'update_env_variables' do
  user "root"
  code <<-EOH
  set -e && set -o pipefail
    ln -s #{node[:saasfee][:montage][:home]}/bin/* /usr/bin/
  EOH
  not_if { ::File.exist?("/usr/bin/mDAG") }
end
