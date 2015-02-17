# git clone Cuneiform
git "/tmp/cuneiform" do
  repository node[:hiway][:cuneiform][:github_url]
  reference "master"
  user node[:hiway][:user]
  group node[:hadoop][:group]
  action :sync
end

# maven build Cuneiform
bash 'build-cuneiform' do
  user node[:hiway][:user]
  group node[:hadoop][:group]
  code <<-EOH
  set -e && set -o pipefail
    mvn -f /tmp/cuneiform/pom.xml package
    cp -r /tmp/cuneiform/cuneiform-dist/target/cuneiform-dist-#{node[:hiway][:cuneiform][:version]}/cuneiform-#{node[:hiway][:cuneiform][:version]} #{node[:hiway][:cuneiform][:home]}
  EOH
  not_if { ::File.exist?("#{node[:hiway][:cuneiform][:home]}") }
end

# add script for calling Cuneiform IDE
template "#{node[:hiway][:cuneiform][:home]}/cfide" do 
  source "cfide.erb"
  owner node[:hiway][:user]
  group node[:hadoop][:group]
  mode "755"
  action :create_if_missing
end

# add script for running Cuneiform
template "#{node[:hiway][:cuneiform][:home]}/cuneiform" do 
  source "cuneiform.erb"
  owner node[:hiway][:user]
  group node[:hadoop][:group]
  mode "755"
  action :create_if_missing
end

# add script for calling Cuneiform log view
template "#{node[:hiway][:cuneiform][:home]}/logview" do 
  source "logview.erb"
  owner node[:hiway][:user]
  group node[:hadoop][:group]
  mode "755"
  action :create_if_missing
end

# add symbolic link to Cuneiform dir
link "#{node[:hadoop][:dir]}/cuneiform" do
  to node[:hiway][:cuneiform][:home]
end

# add CUNEIFORM_HOME environment variable and add it to PATH
bash 'update_env_variables' do
  user node[:hiway][:user]
  group node[:hadoop][:group]
  code <<-EOH
  set -e && set -o pipefail
    echo "export CUNEIFORM_HOME=#{node[:hiway][:cuneiform][:home]}" | tee -a /home/#{node[:hiway][:user]}/.bash*
    echo "export PATH=\\$CUNEIFORM_HOME:\\$PATH" | tee -a /home/#{node[:hiway][:user]}/.bash*
  EOH
  not_if "grep -q CUNEIFORM_HOME /home/#{node[:hiway][:user]}/.bash_profile"
end
