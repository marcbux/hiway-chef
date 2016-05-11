# install XWindows for cfide and logview
package "xorg" do
  options "--force-yes"
end

# install GraphViz for the cfide
package "graphviz" do
  options "--force-yes"
end

# install R for Cuneiform
package "r-base" do
  options "--force-yes"
end

# enable X11 forwarding
bash 'enable_x11_forwarding' do
  user "root"
  code <<-EOH
  set -e && set -o pipefail
    echo "X11Forwarding yes" >> /etc/ssh/sshd_config
  EOH
  not_if "grep -q \"X11Forwarding yes\" /etc/ssh/sshd_config"
end

# create home directory
directory "#{node[:saasfee][:cuneiform][:home]}" do
  owner node[:saasfee][:user]
  group node[:hadoop][:group]
  mode "755"
  recursive true
  action :create
  not_if { File.directory?("#{node[:saasfee][:cuneiform][:home]}") }
end

# download Cuneiform binaries
remote_file "#{node[:saasfee][:cuneiform][:home]}/#{node[:saasfee][:cuneiform][:release][:jar]}" do
  source node[:saasfee][:cuneiform][:release][:url]
  owner node[:saasfee][:user]
  group node[:hadoop][:group]
  mode "775"
  action :create_if_missing
end

# add script for calling Cuneiform IDE
template "#{node[:saasfee][:cuneiform][:home]}/cfide" do 
  source "cfide.erb"
  owner node[:saasfee][:user]
  group node[:hadoop][:group]
  mode "755"
  action :create_if_missing
end

# add script for running Cuneiform
template "#{node[:saasfee][:cuneiform][:home]}/cuneiform" do 
  source "cuneiform.erb"
  owner node[:saasfee][:user]
  group node[:hadoop][:group]
  mode "755"
  action :create_if_missing
end

# add script for calling Cuneiform log view
template "#{node[:saasfee][:cuneiform][:home]}/logview" do 
  source "logview.erb"
  owner node[:saasfee][:user]
  group node[:hadoop][:group]
  mode "755"
  action :create_if_missing
end

# add CUNEIFORM_HOME environment variable
bash 'update_env_variables' do
  user node[:saasfee][:user]
  group node[:hadoop][:group]
  code <<-EOH
  set -e && set -o pipefail
    echo "export CUNEIFORM_HOME=#{node[:saasfee][:cuneiform][:home]}" | tee -a #{node[:saasfee][:home]}/.bash*
  EOH
  not_if "grep -q CUNEIFORM_HOME #{node[:saasfee][:home]}/.bash_profile"
end

# add cuneiform executables to /usr/bin
bash 'update_env_variables' do
  user "root"
  code <<-EOH
  set -e && set -o pipefail
    ln -f -s #{node[:saasfee][:cuneiform][:home]}/cuneiform /usr/bin/
    ln -f -s #{node[:saasfee][:cuneiform][:home]}/cfide /usr/bin/
    ln -f -s #{node[:saasfee][:cuneiform][:home]}/logview /usr/bin/
  EOH
  not_if { ::File.exist?("/usr/bin/cuneiform") }
end
