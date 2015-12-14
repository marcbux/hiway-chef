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

# create reference directory
directory "#{node[:saasfee][:variantcall][:scale][:data]}" do
  owner node[:saasfee][:user]
  group node[:hadoop][:group]
  mode "755"
  action :create
end

# download bowtie2 index
remote_file "#{Chef::Config[:file_cache_path]}/hg19.zip" do
  source "ftp://ftp.ccb.jhu.edu/pub/data/bowtie2_indexes/hg19.zip"
  owner node[:saasfee][:user]
  group node[:hadoop][:group]
  mode "775"
  action :create_if_missing
end

# extract bowtie2 index
if !File.exists?( "#{node[:saasfee][:variantcall][:scale][:index]}.1.bt2" )
  bash 'extract' do
    user node[:saasfee][:user]
    group node[:hadoop][:group]
    code <<-EOH
    set -e
      unzip #{Chef::Config[:file_cache_path]}/hg19.zip -d #{node[:saasfee][:variantcall][:scale][:data]}
    EOH
  end

  bash 'rm_zip' do
    user "root"
    code <<-EOH
    set -e
      rm {Chef::Config[:file_cache_path]}/hg19.zip
    EOH
  end
end

# download reference fasta
chromosomes = ["chr1", "chr2", "chr3", "chr4", "chr5", "chr6", "chr7", "chr8", "chr9", "chr10", "chr11", "chr12", "chr13", "chr14", "chr15", "chr16", "chr17", "chr18", "chr19", "chr20", "chr21", "chr22", "chrX", "chrY", "chrM", "chr1_gl000191_random", "chr1_gl000192_random", "chr4_gl000193_random", "chr4_gl000194_random", "chr7_gl000195_random", "chr8_gl000196_random", "chr8_gl000197_random", "chr9_gl000198_random", "chr9_gl000199_random", "chr9_gl000200_random", "chr9_gl000201_random", "chr11_gl000202_random", "chr17_gl000203_random", "chr17_gl000204_random", "chr17_gl000205_random", "chr17_gl000206_random", "chr18_gl000207_random", "chr19_gl000208_random", "chr19_gl000209_random", "chr21_gl000210_random", "chrUn_gl000211", "chrUn_gl000212", "chrUn_gl000213", "chrUn_gl000214", "chrUn_gl000215", "chrUn_gl000216", "chrUn_gl000217", "chrUn_gl000218", "chrUn_gl000219", "chrUn_gl000220", "chrUn_gl000221", "chrUn_gl000222", "chrUn_gl000223", "chrUn_gl000224", "chrUn_gl000225", "chrUn_gl000226", "chrUn_gl000227", "chrUn_gl000228", "chrUn_gl000229", "chrUn_gl000230", "chrUn_gl000231", "chrUn_gl000232", "chrUn_gl000233", "chrUn_gl000234", "chrUn_gl000235", "chrUn_gl000236", "chrUn_gl000237", "chrUn_gl000238", "chrUn_gl000239", "chrUn_gl000240", "chrUn_gl000241", "chrUn_gl000242", "chrUn_gl000243", "chrUn_gl000244", "chrUn_gl000245", "chrUn_gl000246", "chrUn_gl000247", "chrUn_gl000248", "chrUn_gl000249"]
if !File.exists?( node[:saasfee][:variantcall][:scale][:fa] )
  chromosomes.each do |ref|
    fa = "#{ref}.fa"
    gz = "#{fa}.gz"
    
    remote_file "#{Chef::Config[:file_cache_path]}/#{gz}" do
      source "ftp://hgdownload.cse.ucsc.edu/goldenPath/hg19/chromosomes/#{gz}"
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
    
    bash 'rm_gz' do
      user "root"
      code <<-EOH
      set -e
        rm #{Chef::Config[:file_cache_path]}/#{gz}
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
    annotate_variation.pl -downdb -webfrom annovar refGene -buildver hg19 #{node[:saasfee][:variantcall][:scale][:db]}
  EOH
  not_if { ::File.exists?( node[:saasfee][:variantcall][:scale][:db] ) }
end
