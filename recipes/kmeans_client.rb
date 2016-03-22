package "python-numpy"
package "python-matplotlib"

# prepare the kmeans workflow file
template "#{node[:saasfee][:workflows]}/#{node[:saasfee][:kmeans][:workflow]}" do
  user node[:saasfee][:user]
  group node[:hadoop][:group]
  source "#{node[:saasfee][:kmeans][:workflow]}.erb"
  mode "755"
end
