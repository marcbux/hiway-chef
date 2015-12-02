# download SRA toolkit binaries
remote_file "#{Chef::Config[:file_cache_path]}/#{node[:saasfee][:RNAseq][:sratoolkit][:targz]}" do
  source node[:saasfee][:RNAseq][:sratoolkit][:url]
  owner node[:saasfee][:user]
  group node[:hadoop][:group]
  mode "775"
  action :create_if_missing
end

# install SRA toolkit
bash "install_sratoolkit" do
  user node[:saasfee][:user]
  group node[:hadoop][:group]
  code <<-EOH
  set -e && set -o pipefail
    tar xvfz #{Chef::Config[:file_cache_path]}/#{node[:saasfee][:RNAseq][:sratoolkit][:targz]} -C #{node[:saasfee][:software][:dir]}
  EOH
  not_if { ::File.exist?("#{node[:saasfee][:RNAseq][:sratoolkit][:home]}") }
end

# add SRA toolkit executables to /usr/bin
bash 'update_env_variables' do
  user "root"
  code <<-EOH
  set -e && set -o pipefail
    ln -s #{node[:saasfee][:RNAseq][:sratoolkit][:home]}/bin/* /usr/bin/
  EOH
  not_if { ::File.exist?("/usr/bin/vdb-config") }
end

# create SRA toolkit configuration directory
directory "#{node[:saasfee][:home]}/.ncbi" do
  owner node[:saasfee][:user]
  group node[:hadoop][:group]
  mode "755"
  action :create
end

# create SRA configuration
template "#{node[:saasfee][:home]}/.ncbi/user-settings.mkfg" do
  user node[:saasfee][:user]
  group node[:hadoop][:group]
  source "user-settings.mkfg.erb"
  mode "775"
end

# prepare the RNAseq workflow file
template "#{node[:saasfee][:workflows]}/#{node[:saasfee][:RNAseq][:workflow]}" do
  user node[:saasfee][:user]
  group node[:hadoop][:group]
  source "#{node[:saasfee][:RNAseq][:workflow]}.erb"
  mode "775"
end

# prepare the mouse musculus reference annotation for Cufflinks etc.
cookbook_file "#{Chef::Config[:file_cache_path]}/#{node[:saasfee][:RNAseq][:ref_annotation][:targz]}" do
  source "#{node[:saasfee][:RNAseq][:ref_annotation][:targz]}"
  owner node[:saasfee][:user]
  group node[:hadoop][:group]
  mode "775"
  action :create_if_missing
end

# obtain fastq data and copy input data into hdfs
bash "stage_out_input_data" do
  user node[:saasfee][:user]
  group node[:hadoop][:group]
  timeout 604800
  code <<-EOH
  set -e && set -o pipefail
    tar xzvf #{Chef::Config[:file_cache_path]}/#{node[:saasfee][:RNAseq][:ref_annotation][:targz]} -C #{node[:saasfee][:data]}
    fastq-dump -O #{node[:saasfee][:data]} #{node[:saasfee][:RNAseq][:input1][:replicate1][:accession]}
    fastq-dump -O #{node[:saasfee][:data]} #{node[:saasfee][:RNAseq][:input1][:replicate2][:accession]}
    fastq-dump -O #{node[:saasfee][:data]} #{node[:saasfee][:RNAseq][:input1][:replicate3][:accession]}
    fastq-dump -O #{node[:saasfee][:data]} #{node[:saasfee][:RNAseq][:input2][:replicate1][:accession]}
    fastq-dump -O #{node[:saasfee][:data]} #{node[:saasfee][:RNAseq][:input2][:replicate2][:accession]}
    fastq-dump -O #{node[:saasfee][:data]} #{node[:saasfee][:RNAseq][:input2][:replicate3][:accession]}
    #{node[:hadoop][:home]}/bin/hdfs dfs -put #{node[:saasfee][:data]}/#{node[:saasfee][:RNAseq][:ref_annotation][:gtf]} #{node[:saasfee][:hiway][:hdfs][:basedir]}/#{node[:saasfee][:RNAseq][:ref_annotation][:gtf]}
    #{node[:hadoop][:home]}/bin/hdfs dfs -put #{node[:saasfee][:data]}/#{node[:saasfee][:RNAseq][:input1][:replicate1][:accession]}.fastq #{node[:saasfee][:hiway][:hdfs][:basedir]}/#{node[:saasfee][:RNAseq][:input1][:replicate1][:fastq]}
    #{node[:hadoop][:home]}/bin/hdfs dfs -put #{node[:saasfee][:data]}/#{node[:saasfee][:RNAseq][:input1][:replicate2][:accession]}.fastq #{node[:saasfee][:hiway][:hdfs][:basedir]}/#{node[:saasfee][:RNAseq][:input1][:replicate2][:fastq]}
    #{node[:hadoop][:home]}/bin/hdfs dfs -put #{node[:saasfee][:data]}/#{node[:saasfee][:RNAseq][:input1][:replicate3][:accession]}.fastq #{node[:saasfee][:hiway][:hdfs][:basedir]}/#{node[:saasfee][:RNAseq][:input1][:replicate3][:fastq]}
    #{node[:hadoop][:home]}/bin/hdfs dfs -put #{node[:saasfee][:data]}/#{node[:saasfee][:RNAseq][:input2][:replicate1][:accession]}.fastq #{node[:saasfee][:hiway][:hdfs][:basedir]}/#{node[:saasfee][:RNAseq][:input2][:replicate1][:fastq]}
    #{node[:hadoop][:home]}/bin/hdfs dfs -put #{node[:saasfee][:data]}/#{node[:saasfee][:RNAseq][:input2][:replicate2][:accession]}.fastq #{node[:saasfee][:hiway][:hdfs][:basedir]}/#{node[:saasfee][:RNAseq][:input2][:replicate2][:fastq]}
    #{node[:hadoop][:home]}/bin/hdfs dfs -put #{node[:saasfee][:data]}/#{node[:saasfee][:RNAseq][:input2][:replicate3][:accession]}.fastq #{node[:saasfee][:hiway][:hdfs][:basedir]}/#{node[:saasfee][:RNAseq][:input2][:replicate3][:fastq]}
    rm #{node[:saasfee][:data]}/#{node[:saasfee][:RNAseq][:ref_annotation][:gtf]}
    rm #{node[:saasfee][:data]}/#{node[:saasfee][:RNAseq][:input1][:replicate1][:accession]}.fastq
    rm #{node[:saasfee][:data]}/#{node[:saasfee][:RNAseq][:input1][:replicate2][:accession]}.fastq
    rm #{node[:saasfee][:data]}/#{node[:saasfee][:RNAseq][:input1][:replicate3][:accession]}.fastq
    rm #{node[:saasfee][:data]}/#{node[:saasfee][:RNAseq][:input2][:replicate1][:accession]}.fastq
    rm #{node[:saasfee][:data]}/#{node[:saasfee][:RNAseq][:input2][:replicate2][:accession]}.fastq
    rm #{node[:saasfee][:data]}/#{node[:saasfee][:RNAseq][:input2][:replicate3][:accession]}.fastq
  EOH
  not_if "#{node[:hadoop][:home]}/bin/hdfs dfs -test -e #{node[:saasfee][:hiway][:hdfs][:basedir]}#{node[:saasfee][:RNAseq][:input2][:replicate3][:fastq]}"
end
