remote_file "#{Chef::Config[:file_cache_path]}/#{node[:hiway][:montage_m17_4][:montage][:targz]}" do
  source node[:hiway][:montage_m17_4][:montage][:url]
  owner node[:hiway][:user]
  group node[:hadoop][:group]
  mode "0775"
  action :create_if_missing
end

installed_montage = "/tmp/.installed_montage"
bash "install_montage" do
  user "root"
  code <<-EOF
  set -e && set -o pipefail
  tar xzvf #{Chef::Config[:file_cache_path]}/#{node[:hiway][:montage_m17_4][:montage][:targz]} -C #{node[:hiway][:software][:dir]}
  make -C #{node[:hiway][:montage_m17_4][:montage][:home]}
  ln -s #{node[:hiway][:montage_m17_4][:montage][:home]}/bin/* /usr/bin/
  touch #{installed_montage}
  EOF
    not_if { ::File.exists?( "#{installed_montage}" ) }
end

prepared_montage_m17_4 = "/tmp/.prepared_montage_m17_4"
bash "prepare_montage_m17_4" do
  user node[:hiway][:user]
  group node[:hadoop][:group]
  code <<-EOF
  set -e && set -o pipefail
  
  touch #{prepared_montage_m17_4}
  EOF
    not_if { ::File.exists?( "#{prepared_montage_m17_4}" ) }
end
