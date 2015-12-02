# install unzip
package "unzip" do
  options "--force-yes"
end

# download FastQC binaries
remote_file "#{Chef::Config[:file_cache_path]}/#{node[:saasfee][:variantcall][:fastqc][:zip]}" do
  source node[:saasfee][:variantcall][:fastqc][:url]
  owner node[:saasfee][:user]
  group node[:hadoop][:group]
  mode "775"
  action :create_if_missing
end

# install FastQC
bash "install_fastqc" do
  user node[:saasfee][:user]
  group node[:hadoop][:group]
  code <<-EOH
  set -e && set -o pipefail
    unzip #{Chef::Config[:file_cache_path]}/#{node[:saasfee][:variantcall][:fastqc][:zip]} -d #{node[:saasfee][:software][:dir]}
    chmod a+x #{node[:saasfee][:variantcall][:fastqc][:home]}/fastqc
  EOH
  not_if { ::File.exist?("#{node[:saasfee][:variantcall][:fastqc][:home]}") }
end

# add FastQC executables to /usr/bin
bash 'update_env_variables' do
  user "root"
  code <<-EOH
  set -e && set -o pipefail
    ln -s #{node[:saasfee][:variantcall][:fastqc][:home]}/fastqc /usr/bin/
  EOH
  not_if { ::File.exist?("/usr/bin/fastqc") }
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

# create reference directory
directory "#{node[:saasfee][:data]}/#{node[:saasfee][:variantcall][:reference][:id]}" do
  owner node[:saasfee][:user]
  group node[:hadoop][:group]
  mode "755"
  action :create
end

# download bowtie2 index
remote_file "#{Chef::Config[:file_cache_path]}/#{node[:saasfee][:variantcall][:reference][:id]}.zip" do
  source "ftp://ftp.ccb.jhu.edu/pub/data/bowtie2_indexes/#{node[:saasfee][:variantcall][:reference][:id]}.zip"
  owner node[:saasfee][:user]
  group node[:hadoop][:group]
  mode "775"
  action :create_if_missing
  not_if { ::File.exists?( "#{node[:saasfee][:variantcall][:scale][:index]}.1.bt2" ) }
end

# extract bowtie2 index
bash 'extract' do
  user node[:saasfee][:user]
  group node[:hadoop][:group]
  code <<-EOH
  set -e
    unzip #{Chef::Config[:file_cache_path]}/#{node[:saasfee][:variantcall][:reference][:id]}.zip -d #{node[:saasfee][:data]}/#{node[:saasfee][:variantcall][:reference][:id]}
  EOH
  not_if { ::File.exists?( "#{node[:saasfee][:variantcall][:scale][:index]}.1.bt2" ) }
end

# download reference fasta
if !File.exists?( node[:saasfee][:variantcall][:scale][:fa] )
  node[:saasfee][:variantcall][:reference][:chromosomes].each do |ref|
    fa = "#{ref}.fa"
    gz = "#{fa}.gz"
    
    remote_file "#{Chef::Config[:file_cache_path]}/#{gz}" do
      source "#{node[:saasfee][:variantcall][:reference][:url_base]}/#{gz}"
      owner node[:saasfee][:user]
      group node[:hadoop][:group]
      mode "775"
      action :create_if_missing
    end
    
    bash 'extract' do
      user node[:saasfee][:user]
      group node[:hadoop][:group]
      code <<-EOH
      set -e
        gzip -c -d "#{Chef::Config[:file_cache_path]}/#{gz}" >> #{node[:saasfee][:variantcall][:scale][:fa]}
      EOH
    end
  end
end

# build samtools fai
bash 'build_fai' do
  user node[:saasfee][:user]
  group node[:hadoop][:group]
  code <<-EOH
  set -e
    samtools faidx #{node[:saasfee][:variantcall][:scale][:fa]}
  EOH
  not_if { ::File.exists?( "#{node[:saasfee][:variantcall][:scale][:fa]}.fai" ) }
end

# obtain annovar db
bash 'download_annovar_db' do
  user node[:saasfee][:user]
  group node[:hadoop][:group]
  code <<-EOH
  set -e
    annotate_variation.pl -downdb -webfrom annovar refGene -buildver #{node[:saasfee][:variantcall][:reference][:id]} #{node[:saasfee][:variantcall][:scale][:db]}
  EOH
  not_if { ::File.exists?( node[:saasfee][:variantcall][:scale][:db] ) }
end
