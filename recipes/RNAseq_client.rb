# download SRA toolkit binaries
remote_file "#{Chef::Config[:file_cache_path]}/#{node[:hiway][:RNAseq][:sratoolkit][:targz]}" do
  source node[:hiway][:RNAseq][:sratoolkit][:url]
  owner node[:hiway][:user]
  group node[:hadoop][:group]
  mode "775"
  action :create_if_missing
end

# install SRA toolkit
bash "install_sratoolkit" do
  user node[:hiway][:user]
  group node[:hadoop][:group]
  code <<-EOH
  set -e && set -o pipefail
    tar xvfz #{Chef::Config[:file_cache_path]}/#{node[:hiway][:RNAseq][:sratoolkit][:targz]} -C #{node[:hiway][:software][:dir]}
  EOH
  not_if { ::File.exist?("#{node[:hiway][:RNAseq][:sratoolkit][:home]}") }
end

# add SRA toolkit executables to /usr/bin
bash 'update_env_variables' do
  user "root"
  code <<-EOH
  set -e && set -o pipefail
    ln -s #{node[:hiway][:RNAseq][:sratoolkit][:home]}/bin/* /usr/bin/
  EOH
  not_if { ::File.exist?("/usr/bin/vdb-config") }
end

# create SRA toolkit configuration directory
directory "#{node[:hiway][:home]}/.ncbi" do
  owner node[:hiway][:user]
  group node[:hadoop][:group]
  mode "755"
  action :create
end

# create SRA configuration
template "#{node[:hiway][:home]}/.ncbi/user-settings.mkfg" do
  user node[:hiway][:user]
  group node[:hadoop][:group]
  source "user-settings.mkfg.erb"
  mode "775"
end

# prepare the RNAseq workflow file
template "#{node[:hiway][:data]}/#{node[:hiway][:RNAseq][:workflow]}" do
  user node[:hiway][:user]
  group node[:hadoop][:group]
  source "#{node[:hiway][:RNAseq][:workflow]}.erb"
  mode "775"
end

# prepare the mouse musculus reference annotation for Cufflinks etc.
cookbook_file "#{Chef::Config[:file_cache_path]}/#{node[:hiway][:RNAseq][:ref_annotation][:targz]}" do
  source "#{node[:hiway][:RNAseq][:ref_annotation][:targz]}"
  owner node[:hiway][:user]
  group node[:hadoop][:group]
  mode "775"
  action :create_if_missing
end

# obtain fastq data and copy input data into hdfs
bash "stage_out_input_data" do
  user node[:hiway][:user]
  group node[:hadoop][:group]
  timeout 604800
  code <<-EOH
  set -e && set -o pipefail
    tar xzvf #{Chef::Config[:file_cache_path]}/#{node[:hiway][:RNAseq][:ref_annotation][:targz]} -C #{node[:hiway][:data]}
    fastq-dump -O #{node[:hiway][:data]} #{node[:hiway][:RNAseq][:input1][:replicate1][:accession]}
    fastq-dump -O #{node[:hiway][:data]} #{node[:hiway][:RNAseq][:input1][:replicate2][:accession]}
    fastq-dump -O #{node[:hiway][:data]} #{node[:hiway][:RNAseq][:input1][:replicate3][:accession]}
    fastq-dump -O #{node[:hiway][:data]} #{node[:hiway][:RNAseq][:input2][:replicate1][:accession]}
    fastq-dump -O #{node[:hiway][:data]} #{node[:hiway][:RNAseq][:input2][:replicate2][:accession]}
    fastq-dump -O #{node[:hiway][:data]} #{node[:hiway][:RNAseq][:input2][:replicate3][:accession]}
    #{node[:hadoop][:home]}/bin/hdfs dfs -put #{node[:hiway][:data]}/#{node[:hiway][:RNAseq][:ref_annotation][:gtf]} #{node[:hiway][:hiway][:hdfs][:basedir]}/#{node[:hiway][:RNAseq][:ref_annotation][:gtf]}
    #{node[:hadoop][:home]}/bin/hdfs dfs -put #{node[:hiway][:data]}/#{node[:hiway][:RNAseq][:input1][:replicate1][:accession]}.fastq #{node[:hiway][:hiway][:hdfs][:basedir]}/#{node[:hiway][:RNAseq][:input1][:replicate1][:fastq]}
    #{node[:hadoop][:home]}/bin/hdfs dfs -put #{node[:hiway][:data]}/#{node[:hiway][:RNAseq][:input1][:replicate2][:accession]}.fastq #{node[:hiway][:hiway][:hdfs][:basedir]}/#{node[:hiway][:RNAseq][:input1][:replicate2][:fastq]}
    #{node[:hadoop][:home]}/bin/hdfs dfs -put #{node[:hiway][:data]}/#{node[:hiway][:RNAseq][:input1][:replicate3][:accession]}.fastq #{node[:hiway][:hiway][:hdfs][:basedir]}/#{node[:hiway][:RNAseq][:input1][:replicate3][:fastq]}
    #{node[:hadoop][:home]}/bin/hdfs dfs -put #{node[:hiway][:data]}/#{node[:hiway][:RNAseq][:input2][:replicate1][:accession]}.fastq #{node[:hiway][:hiway][:hdfs][:basedir]}/#{node[:hiway][:RNAseq][:input2][:replicate1][:fastq]}
    #{node[:hadoop][:home]}/bin/hdfs dfs -put #{node[:hiway][:data]}/#{node[:hiway][:RNAseq][:input2][:replicate2][:accession]}.fastq #{node[:hiway][:hiway][:hdfs][:basedir]}/#{node[:hiway][:RNAseq][:input2][:replicate2][:fastq]}
    #{node[:hadoop][:home]}/bin/hdfs dfs -put #{node[:hiway][:data]}/#{node[:hiway][:RNAseq][:input2][:replicate3][:accession]}.fastq #{node[:hiway][:hiway][:hdfs][:basedir]}/#{node[:hiway][:RNAseq][:input2][:replicate3][:fastq]}
    rm #{node[:hiway][:data]}/#{node[:hiway][:RNAseq][:ref_annotation][:gtf]}
    rm #{node[:hiway][:data]}/#{node[:hiway][:RNAseq][:input1][:replicate1][:accession]}.fastq
    rm #{node[:hiway][:data]}/#{node[:hiway][:RNAseq][:input1][:replicate2][:accession]}.fastq
    rm #{node[:hiway][:data]}/#{node[:hiway][:RNAseq][:input1][:replicate3][:accession]}.fastq
    rm #{node[:hiway][:data]}/#{node[:hiway][:RNAseq][:input2][:replicate1][:accession]}.fastq
    rm #{node[:hiway][:data]}/#{node[:hiway][:RNAseq][:input2][:replicate2][:accession]}.fastq
    rm #{node[:hiway][:data]}/#{node[:hiway][:RNAseq][:input2][:replicate3][:accession]}.fastq
  EOH
  not_if "#{node[:hadoop][:home]}/bin/hdfs dfs -test -e #{node[:hiway][:hiway][:hdfs][:basedir]}#{node[:hiway][:RNAseq][:input2][:replicate3][:fastq]}"
end
