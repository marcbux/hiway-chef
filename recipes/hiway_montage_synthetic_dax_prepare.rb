# download the synthetic montage workflow file
remote_file "#{node[:hiway][:home]}/#{node[:hiway][:montage_synthetic][:workflow]}" do
  source node[:hiway][:montage_synthetic][:url]
  owner node[:hiway][:user]
  group node[:hadoop][:group]
  mode "775"
  action :create_if_missing
end
