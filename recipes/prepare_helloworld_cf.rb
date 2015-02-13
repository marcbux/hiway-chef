template "#{node[:hiway][:home]}/#{node[:hiway][:helloworld][:workflow]}" do
  user node[:hiway][:user]
  group node[:hadoop][:group]
  source "#{node[:hiway][:helloworld][:workflow]}.erb"
  mode "0774"
end
