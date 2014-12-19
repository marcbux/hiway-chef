remote_file "#{Chef::Config[:file_cache_path]}/#{node[:hiway][:variantcall][:bowtie2][:zip]}" do
  source node[:hiway][:variantcall][:bowtie2][:url]
  owner node[:hiway][:user]
  group node[:hiway][:group]
  mode "0775"
  action :create_if_missing
end

remote_file "#{Chef::Config[:file_cache_path]}/#{node[:hiway][:variantcall][:samtools][:tarbz2]}" do
  source node[:hiway][:variantcall][:samtools][:url]
  owner node[:hiway][:user]
  group node[:hiway][:group]
  mode "0775"
  action :create_if_missing
end

remote_file "#{node[:hiway][:dir]}/#{node[:hiway][:variantcall][:varscan][:jar]}" do
  source node[:hiway][:variantcall][:varscan][:url]
  owner node[:hiway][:user]
  group node[:hiway][:group]
  mode "0775"
  action :create_if_missing
end

remote_file "#{Chef::Config[:file_cache_path]}/#{node[:hiway][:variantcall][:annovar][:targz]}" do
  source node[:hiway][:variantcall][:annovar][:url]
  owner node[:hiway][:user]
  group node[:hiway][:group]
  mode "0775"
  action :create_if_missing
end

bash "install_bowtie2" do
  user "root"
  code <<-EOF
  set -e && set -o pipefail
  apt-get install unzip -y
  unzip #{Chef::Config[:file_cache_path]}/#{node[:hiway][:variantcall][:bowtie2][:zip]} -d #{node[:hiway][:dir]}
  ln -f -s #{node[:hiway][:variantcall][:bowtie2][:home]}/bowtie2* /usr/bin/
  EOF
#    not_if { ::File.exists?( "#{installed_bowtie2}" ) }
end

bash "install_samtools" do
  user "root"
  code <<-EOF
  set -e && set -o pipefail
  apt-get install libncurses5-dev -y
  tar xjvf #{Chef::Config[:file_cache_path]}/#{node[:hiway][:variantcall][:samtools][:tarbz2]} -C #{node[:hiway][:dir]}
  make -C #{node[:hiway][:variantcall][:samtools][:home]}
  ln -s #{node[:hiway][:variantcall][:samtools][:home]}/samtools /usr/bin/
  EOF
#    not_if { ::File.exists?( "#{installed_samtools}" ) }
end

bash "install_varscan" do
  user "root"
  code <<-EOF
  set -e && set -o pipefail
  ln -s #{node[:hiway][:dir]}/#{node[:hiway][:variantcall][:varscan][:jar]} \$JAVA_HOME/jre/lib/ext/
  EOF
#    not_if { ::File.exists?( "#{installed_varscan}" ) }
end

bash "install_annovar" do
  user "root"
  code <<-EOF
  set -e && set -o pipefail
  tar xvfz #{Chef::Config[:file_cache_path]}/#{node[:hiway][:variantcall][:annovar][:targz]} -C #{node[:hiway][:dir]}
  ln -f -s #{node[:hiway][:variantcall][:annovar][:home]}/*.pl /usr/bin/
  EOF
#    not_if { ::File.exists?( "#{installed_annovar}" ) }
end
