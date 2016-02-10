# install g++, which is required for building Montage
package "g++" do
  options "--force-yes"
end

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

# create input data directory
directory "#{node[:saasfee][:data]}/montage" do
  owner node[:saasfee][:user]
  group node[:hadoop][:group]
  mode "755"
  action :create
end

# obtain input data
bash "obtain_montage_input_data" do
  user node[:saasfee][:user]
  group node[:hadoop][:group]
  timeout 604800
  code <<-EOH
  set -e && set -o pipefail
    cd #{node[:saasfee][:data]}/montage
    mDAG 2mass j #{node[:saasfee][:montage][:region]} #{node[:saasfee][:montage][:degree]} #{node[:saasfee][:montage][:degree]} 0.000278 #{node[:saasfee][:data]}/montage file:/ | grep -o '[0-9_]*' > #{Chef::Config[:file_cache_path]}/id
    sed -i "s#_`cat #{Chef::Config[:file_cache_path]}/id`##g" #{node[:saasfee][:data]}/montage/*
    for i in 2mass big_region.hdr cache.list cimages dag.xml diffs.tbl images.tbl pimages.tbl region rimages.tbl shrunken.hdr slist.tbl statfile.tbl url.list; do
      sed -i "s#file=\\"$i#file=\\"montage/$i#g" #{node[:saasfee][:data]}/montage/dag.xml
    done
    cp #{node[:saasfee][:data]}/montage/dag.xml #{node[:saasfee][:workflows]}/montage.xml
    mArchiveExec images.tbl
  EOH
  not_if { ::File.exist?("#{node[:saasfee][:workflows]}/montage.xml") }
end

# move input data to hdfs
bash "move_montage_input_to_hdfs" do
  user node[:saasfee][:user]
  group node[:hadoop][:group]
  code <<-EOH
  set -e && set -o pipefail
    #{node[:hadoop][:home]}/bin/hdfs dfs -put #{node[:saasfee][:data]}/montage #{node[:saasfee][:hiway][:hdfs][:basedir]}/montage
    rm #{node[:saasfee][:data]}/montage
  EOH
  not_if "#{node[:hadoop][:home]}/bin/hdfs dfs -test -e #{node[:saasfee][:hiway][:hdfs][:basedir]}/montage"
end
