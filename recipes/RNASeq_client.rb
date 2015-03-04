# prepare the RNASeq workflow file
template "#{node[:hiway][:home]}/#{node[:hiway][:RNASeq][:workflow]}" do
  user node[:hiway][:user]
  group node[:hadoop][:group]
  source "#{node[:hiway][:RNASeq][:workflow]}.erb"
  mode "775"
end

# prepare the mouse musculus reference annotation for Cufflinks etc.
template "#{Chef::Config[:file_cache_path]}/#{node[:hiway][:RNASeq][:ref_annotation][:targz]}" do
  user node[:hiway][:user]
  group node[:hadoop][:group]
  source "#{node[:hiway][:RNASeq][:ref_annotation][:targz]}.erb"
  mode "775"
end

# prepare input: sample 1, replicate 1
remote_file "#{node[:hiway][:home]}/#{node[:hiway][:RNASeq][:input1][:recplicate1][:fastq]}" do
  source "#{node[:hiway][:RNASeq][:input1][:recplicate1][:url]}"
  owner node[:hiway][:user]
  group node[:hadoop][:group]
  mode "775"
  action :create_if_missing
end

# prepare input: sample 1, replicate 2
remote_file "#{node[:hiway][:home]}/#{node[:hiway][:RNASeq][:input1][:recplicate2][:fastq]}" do
  source "#{node[:hiway][:RNASeq][:input1][:recplicate2][:url]}"
  owner node[:hiway][:user]
  group node[:hadoop][:group]
  mode "775"
  action :create_if_missing
end

# prepare input: sample 1, replicate 3
remote_file "#{node[:hiway][:home]}/#{node[:hiway][:RNASeq][:input1][:recplicate3][:fastq]}" do
  source "#{node[:hiway][:RNASeq][:input1][:recplicate3][:url]}"
  owner node[:hiway][:user]
  group node[:hadoop][:group]
  mode "775"
  action :create_if_missing
end

# prepare input: sample 2, replicate 1
remote_file "#{node[:hiway][:home]}/#{node[:hiway][:RNASeq][:input2][:recplicate1][:fastq]}" do
  source "#{node[:hiway][:RNASeq][:input2][:recplicate1][:url]}"
  owner node[:hiway][:user]
  group node[:hadoop][:group]
  mode "775"
  action :create_if_missing
end

# prepare input: sample 2, replicate 2
remote_file "#{node[:hiway][:home]}/#{node[:hiway][:RNASeq][:input2][:recplicate2][:fastq]}" do
  source "#{node[:hiway][:RNASeq][:input2][:recplicate2][:url]}"
  owner node[:hiway][:user]
  group node[:hadoop][:group]
  mode "775"
  action :create_if_missing
end

# prepare input: sample 2, replicate 3
remote_file "#{node[:hiway][:home]}/#{node[:hiway][:RNASeq][:input2][:recplicate3][:fastq]}" do
  source "#{node[:hiway][:RNASeq][:input2][:recplicate3][:url]}"
  owner node[:hiway][:user]
  group node[:hadoop][:group]
  mode "775"
  action :create_if_missing
end

# copy input data into hdfs
bash "stage_out_input_data" do
  user node[:hiway][:user]
  group node[:hadoop][:group]
  code <<-EOH
  set -e && set -o pipefail
    tar xzvf #{Chef::Config[:file_cache_path]}/#{node[:hiway][:RNASeq][:ref_annotation][:targz]} -C #{node[:hiway][:home]}
    #{node[:hadoop][:home]}/bin/hdfs dfs -put #{node[:hiway][:home]}/#{node[:hiway][:RNASeq][:ref_annotation][:gtf]} #{node[:hiway][:hiway][:hdfs][:basedir]}
    #{node[:hadoop][:home]}/bin/hdfs dfs -put #{node[:hiway][:home]}/#{node[:hiway][:RNASeq][:input1][:recplicate1][:fastq]} #{node[:hiway][:hiway][:hdfs][:basedir]}
    #{node[:hadoop][:home]}/bin/hdfs dfs -put #{node[:hiway][:home]}/#{node[:hiway][:RNASeq][:input1][:recplicate2][:fastq]} #{node[:hiway][:hiway][:hdfs][:basedir]}
    #{node[:hadoop][:home]}/bin/hdfs dfs -put #{node[:hiway][:home]}/#{node[:hiway][:RNASeq][:input1][:recplicate3][:fastq]} #{node[:hiway][:hiway][:hdfs][:basedir]}
    #{node[:hadoop][:home]}/bin/hdfs dfs -put #{node[:hiway][:home]}/#{node[:hiway][:RNASeq][:input2][:recplicate1][:fastq]} #{node[:hiway][:hiway][:hdfs][:basedir]}
    #{node[:hadoop][:home]}/bin/hdfs dfs -put #{node[:hiway][:home]}/#{node[:hiway][:RNASeq][:input2][:recplicate2][:fastq]} #{node[:hiway][:hiway][:hdfs][:basedir]}
    #{node[:hadoop][:home]}/bin/hdfs dfs -put #{node[:hiway][:home]}/#{node[:hiway][:RNASeq][:input2][:recplicate3][:fastq]} #{node[:hiway][:hiway][:hdfs][:basedir]}
    rm #{node[:hiway][:home]}/#{node[:hiway][:RNASeq][:ref_annotation][:gtf]}
    rm #{node[:hiway][:home]}/#{node[:hiway][:RNASeq][:input1][:recplicate1][:fastq]}
    rm #{node[:hiway][:home]}/#{node[:hiway][:RNASeq][:input1][:recplicate2][:fastq]}
    rm #{node[:hiway][:home]}/#{node[:hiway][:RNASeq][:input1][:recplicate3][:fastq]}
    rm #{node[:hiway][:home]}/#{node[:hiway][:RNASeq][:input2][:recplicate1][:fastq]}
    rm #{node[:hiway][:home]}/#{node[:hiway][:RNASeq][:input2][:recplicate2][:fastq]}
    rm #{node[:hiway][:home]}/#{node[:hiway][:RNASeq][:input2][:recplicate3][:fastq]}
  EOH
  not_if "#{node[:hadoop][:home]}/bin/hdfs dfs -test -e #{node[:hiway][:hiway][:hdfs][:basedir]}#{node[:hiway][:RNASeq][:input2][:recplicate3][:fastq]}"
end
