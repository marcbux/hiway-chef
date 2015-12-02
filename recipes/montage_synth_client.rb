# download the synthetic montage workflow file
remote_file "#{node[:saasfee][:workflows]}/#{node[:saasfee][:montage_synthetic][:workflow]}" do
  source node[:saasfee][:montage_synthetic][:url]
  owner node[:saasfee][:user]
  group node[:hadoop][:group]
  mode "775"
  action :create_if_missing
end
