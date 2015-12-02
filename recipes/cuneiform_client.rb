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

# adjust resolution of the terminal
#bash 'adjust_resolution' do
#  user "root"
#  code <<-EOH
#  set -e && set -o pipefail
#    echo "GRUB_GFXMODE=#{node[:saasfee][:resolution]}" >> /etc/default/grub
#    sed -i s/GRUB_GFXMODE=auto/GRUB_GFXMODE=#{node[:saasfee][:resolution]}/ /etc/grub.d/00_header
#    update-grub2
#  EOH
#  not_if "grep -q #{node[:saasfee][:resolution]} /etc/default/grub && grep -q #{node[:saasfee][:resolution]} /etc/grub.d/00_header"
#end

if node[:saasfee][:release] == "true"
  # download Cuneiform binaries
  remote_file "#{Chef::Config[:file_cache_path]}/#{node[:saasfee][:cuneiform][:release][:targz]}" do
    source node[:saasfee][:cuneiform][:release][:url]
    owner node[:saasfee][:user]
    group node[:hadoop][:group]
    mode "775"
    action :create_if_missing
  end
  
  # install Cuneiform binaries
  bash "install_cuneiform" do
    user node[:saasfee][:user]
    group node[:hadoop][:group]
    code <<-EOH
    set -e && set -o pipefail
      tar xvfz #{Chef::Config[:file_cache_path]}/#{node[:saasfee][:cuneiform][:release][:targz]} -C #{node[:saasfee][:software][:dir]}
    EOH
    not_if { ::File.exist?("#{node[:saasfee][:cuneiform][:home]}") }
  end
else
  # install Git
  include_recipe "git"
  
  # install Maven
  package "maven" do
    options "--force-yes"
  end
  
  # git clone Cuneiform
  git "/tmp/cuneiform" do
    repository node[:saasfee][:cuneiform][:github_url]
    reference "master"
    user node[:saasfee][:user]
    group node[:hadoop][:group]
    action :sync
  end

  # maven build Cuneiform
  bash 'build-cuneiform' do
    user node[:saasfee][:user]
    group node[:hadoop][:group]
    code <<-EOH
    set -e && set -o pipefail
      mvn -f /tmp/cuneiform/pom.xml package
      version=$(grep -Po '(?<=^\t<version>)[^<]*(?=</version>)' /tmp/cuneiform/pom.xml)
      cp -r /tmp/cuneiform/cuneiform-dist/target/cuneiform-dist-$version/cuneiform-$version #{node[:saasfee][:cuneiform][:home]}
    EOH
    not_if { ::File.exist?("#{node[:saasfee][:cuneiform][:home]}") }
  end
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
