# install unzip
package "unzip" do
  options "--force-yes"
end

# download bowtie2 binaries
remote_file "#{Chef::Config[:file_cache_path]}/#{node[:saasfee][:variantcall][:bowtie2][:zip]}" do
  source node[:saasfee][:variantcall][:bowtie2][:url]
  owner node[:saasfee][:user]
  group node[:hadoop][:group]
  mode "775"
  action :create_if_missing
end

# install bowtie2
bash "install_bowtie2" do
  user node[:saasfee][:user]
  group node[:hadoop][:group]
  code <<-EOH
  set -e && set -o pipefail
    unzip #{Chef::Config[:file_cache_path]}/#{node[:saasfee][:variantcall][:bowtie2][:zip]} -d #{node[:saasfee][:software][:dir]}
  EOH
  not_if { ::File.exist?("#{node[:saasfee][:variantcall][:bowtie2][:home]}") }
end

# add bowtie2 executables to /usr/bin
bash 'update_env_variables' do
  user "root"
  code <<-EOH
  set -e && set -o pipefail
    ln -s #{node[:saasfee][:variantcall][:bowtie2][:home]}/bowtie2* /usr/bin/
  EOH
  not_if { ::File.exist?("/usr/bin/bowtie2") }
end

# install zlib, which is required for building samtools
package "zlib1g-dev" do
  options "--force-yes"
end

# install libcurses, which is required for building samtools
package "libncurses5-dev" do
  options "--force-yes"
end

# download samtools sources
remote_file "#{Chef::Config[:file_cache_path]}/#{node[:saasfee][:variantcall][:samtools][:tarbz2]}" do
  source node[:saasfee][:variantcall][:samtools][:url]
  owner node[:saasfee][:user]
  group node[:hadoop][:group]
  mode "775"
  action :create_if_missing
end

# compile and install samtools
bash "install_samtools" do
  user node[:saasfee][:user]
  group node[:hadoop][:group]
  code <<-EOH
  set -e && set -o pipefail
    tar xjvf #{Chef::Config[:file_cache_path]}/#{node[:saasfee][:variantcall][:samtools][:tarbz2]} -C #{node[:saasfee][:software][:dir]}
    make -C #{node[:saasfee][:variantcall][:samtools][:home]}
  EOH
  not_if { ::File.exist?("#{node[:saasfee][:variantcall][:samtools][:home]}") }
end

# add samtools executable to /usr/bin
bash 'update_env_variables' do
  user "root"
  code <<-EOH
  set -e && set -o pipefail
    ln -s #{node[:saasfee][:variantcall][:samtools][:home]}/samtools /usr/bin/
  EOH
  not_if { ::File.exist?("/usr/bin/samtools") }
end

# create varscan directory
directory node[:saasfee][:variantcall][:varscan][:home] do
  owner node[:saasfee][:user]
  group node[:hadoop][:group]
  mode "755"
  action :create
end

# download varscan jar
remote_file "#{node[:saasfee][:variantcall][:varscan][:home]}/#{node[:saasfee][:variantcall][:varscan][:jar]}" do
  source node[:saasfee][:variantcall][:varscan][:url]
  owner node[:saasfee][:user]
  group node[:hadoop][:group]
  mode "775"
  action :create_if_missing
end

# add script for running varscan
template "#{node[:saasfee][:variantcall][:varscan][:home]}/varscan" do 
  source "varscan.erb"
  owner node[:saasfee][:user]
  group node[:hadoop][:group]
  mode "755"
  action :create_if_missing
end

# add varscan executable to /usr/bin
bash 'update_env_variables' do
  user "root"
  code <<-EOH
  set -e && set -o pipefail
    ln -s #{node[:saasfee][:variantcall][:varscan][:home]}/varscan /usr/bin/
  EOH
  not_if { ::File.exist?("/usr/bin/varscan") }
end

# download annovar binaries
remote_file "#{Chef::Config[:file_cache_path]}/#{node[:saasfee][:variantcall][:annovar][:targz]}" do
  source node[:saasfee][:variantcall][:annovar][:url]
  owner node[:saasfee][:user]
  group node[:hadoop][:group]
  mode "775"
  action :create_if_missing
end

# install annovar
bash "install_annovar" do
  user node[:saasfee][:user]
  group node[:hadoop][:group]
  code <<-EOH
  set -e && set -o pipefail
    tar xvfz #{Chef::Config[:file_cache_path]}/#{node[:saasfee][:variantcall][:annovar][:targz]} -C #{node[:saasfee][:software][:dir]}
  EOH
  not_if { ::File.exist?("#{node[:saasfee][:variantcall][:annovar][:home]}") }
end

# add annovar executables to /usr/bin
bash 'update_env_variables' do
  user "root"
  code <<-EOH
  set -e && set -o pipefail
    ln -s #{node[:saasfee][:variantcall][:annovar][:home]}/*.pl /usr/bin/
  EOH
  not_if { ::File.exist?("/usr/bin/annotate_variation.pl") }
end

# download worker data from S3
remote_file "#{node[:saasfee][:data]}/hg19.tar.gz" do
  source node[:saasfee][:variantcall][:scale][:url]
  owner node[:saasfee][:user]
  group node[:hadoop][:group]
  mode "775"
  action :create_if_missing
end

# extract worker data
bash "extract_data" do
  user node[:saasfee][:user]
  group node[:hadoop][:group]
  code <<-EOH
  set -e && set -o pipefail
    tar -zxvf #{node[:saasfee][:data]}/hg19.tar.gz -C #{node[:saasfee][:data]}
    rm #{node[:saasfee][:data]}/hg19.tar.gz
  EOH
  not_if { ::File.exist?("#{node[:saasfee][:variantcall][:scale][:data]}") }
end
