# prepare the hello world workflow file
template "#{node[:saasfee][:workflows]}/#{node[:saasfee][:helloworld][:workflow]}" do
  user node[:saasfee][:user]
  group node[:hadoop][:group]
  source "#{node[:saasfee][:helloworld][:workflow]}.erb"
  mode "755"
end
