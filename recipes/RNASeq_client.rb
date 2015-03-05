# download SRA toolkit binaries
remote_file "#{Chef::Config[:file_cache_path]}/#{node[:hiway][:RNASeq][:sratoolkit][:targz]}" do
  source node[:hiway][:RNASeq][:sratoolkit][:url]
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
    tar xvfz #{Chef::Config[:file_cache_path]}/#{node[:hiway][:RNASeq][:sratoolkit][:targz]} -C #{node[:hiway][:software][:dir]}
  EOH
  not_if { ::File.exist?("#{node[:hiway][:RNASeq][:sratoolkit][:home]}") }
end

# add SRA toolkit executables to /usr/bin
bash 'update_env_variables' do
  user "root"
  code <<-EOH
  set -e && set -o pipefail
    ln -s #{node[:hiway][:RNASeq][:sratoolkit][:home]}/bin/* /usr/bin/
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

# prepare the RNASeq workflow file
template "#{node[:hiway][:home]}/#{node[:hiway][:RNASeq][:workflow]}" do
  user node[:hiway][:user]
  group node[:hadoop][:group]
  source "#{node[:hiway][:RNASeq][:workflow]}.erb"
  mode "775"
end

# prepare the mouse musculus reference annotation for Cufflinks etc.
cookbook_file "#{Chef::Config[:file_cache_path]}/#{node[:hiway][:RNASeq][:ref_annotation][:targz]}" do
  source "#{node[:hiway][:RNASeq][:ref_annotation][:targz]}"
  owner node[:hiway][:user]
  group node[:hadoop][:group]
  mode "775"
  action :create_if_missing
end

# obtain fastq data and copy input data into hdfs
bash "stage_out_input_data" do
  user node[:hiway][:user]
  group node[:hadoop][:group]
  code <<-EOH
  set -e && set -o pipefail
    tar xzvf #{Chef::Config[:file_cache_path]}/#{node[:hiway][:RNASeq][:ref_annotation][:targz]} -C #{node[:hiway][:home]}
    fastq-dump -O #{node[:hiway][:home]} #{node[:hiway][:RNASeq][:input1][:replicate1][:accession]}
    fastq-dump -O #{node[:hiway][:home]} #{node[:hiway][:RNASeq][:input1][:replicate2][:accession]}
    fastq-dump -O #{node[:hiway][:home]} #{node[:hiway][:RNASeq][:input1][:replicate3][:accession]}
    fastq-dump -O #{node[:hiway][:home]} #{node[:hiway][:RNASeq][:input2][:replicate1][:accession]}
    fastq-dump -O #{node[:hiway][:home]} #{node[:hiway][:RNASeq][:input2][:replicate2][:accession]}
    fastq-dump -O #{node[:hiway][:home]} #{node[:hiway][:RNASeq][:input2][:replicate3][:accession]}
    #{node[:hadoop][:home]}/bin/hdfs dfs -put #{node[:hiway][:home]}/#{node[:hiway][:RNASeq][:ref_annotation][:gtf]} #{node[:hiway][:hiway][:hdfs][:basedir]}
    #{node[:hadoop][:home]}/bin/hdfs dfs -put #{node[:hiway][:home]}/#{node[:hiway][:RNASeq][:input1][:replicate1][:accession]}.fastq #{node[:hiway][:hiway][:hdfs][:basedir]}#{node[:hiway][:RNASeq][:input1][:replicate1][:fastq]}
    #{node[:hadoop][:home]}/bin/hdfs dfs -put #{node[:hiway][:home]}/#{node[:hiway][:RNASeq][:input1][:replicate2][:accession]}.fastq #{node[:hiway][:hiway][:hdfs][:basedir]}#{node[:hiway][:RNASeq][:input1][:replicate2][:fastq]}
    #{node[:hadoop][:home]}/bin/hdfs dfs -put #{node[:hiway][:home]}/#{node[:hiway][:RNASeq][:input1][:replicate3][:accession]}.fastq #{node[:hiway][:hiway][:hdfs][:basedir]}#{node[:hiway][:RNASeq][:input1][:replicate3][:fastq]}
    #{node[:hadoop][:home]}/bin/hdfs dfs -put #{node[:hiway][:home]}/#{node[:hiway][:RNASeq][:input2][:replicate1][:accession]}.fastq #{node[:hiway][:hiway][:hdfs][:basedir]}#{node[:hiway][:RNASeq][:input2][:replicate1][:fastq]}
    #{node[:hadoop][:home]}/bin/hdfs dfs -put #{node[:hiway][:home]}/#{node[:hiway][:RNASeq][:input2][:replicate2][:accession]}.fastq #{node[:hiway][:hiway][:hdfs][:basedir]}#{node[:hiway][:RNASeq][:input2][:replicate2][:fastq]}
    #{node[:hadoop][:home]}/bin/hdfs dfs -put #{node[:hiway][:home]}/#{node[:hiway][:RNASeq][:input2][:replicate3][:accession]}.fastq #{node[:hiway][:hiway][:hdfs][:basedir]}#{node[:hiway][:RNASeq][:input2][:replicate3][:fastq]}
    rm #{node[:hiway][:home]}/#{node[:hiway][:RNASeq][:ref_annotation][:gtf]}
    rm #{node[:hiway][:home]}/#{node[:hiway][:RNASeq][:input1][:replicate1][:accession]}.fastq
    rm #{node[:hiway][:home]}/#{node[:hiway][:RNASeq][:input1][:replicate2][:accession]}.fastq
    rm #{node[:hiway][:home]}/#{node[:hiway][:RNASeq][:input1][:replicate3][:accession]}.fastq
    rm #{node[:hiway][:home]}/#{node[:hiway][:RNASeq][:input2][:replicate1][:accession]}.fastq
    rm #{node[:hiway][:home]}/#{node[:hiway][:RNASeq][:input2][:replicate2][:accession]}.fastq
    rm #{node[:hiway][:home]}/#{node[:hiway][:RNASeq][:input2][:replicate3][:accession]}.fastq
  EOH
  not_if "#{node[:hadoop][:home]}/bin/hdfs dfs -test -e #{node[:hiway][:hiway][:hdfs][:basedir]}#{node[:hiway][:RNASeq][:input2][:replicate3][:fastq]}"
end
