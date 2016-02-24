package "sysstat"
package "ifstat"
package "htop"

# prepare the performance file
template "#{node[:saasfee][:home]}/perf.sh" do
  user node[:saasfee][:user]
  group node[:hadoop][:group]
  source "perf.sh.erb"
  mode "754"
end
