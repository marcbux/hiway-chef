# prepare the variant call workflow file
template "#{node[:hiway][:data]}/#{node[:hiway][:variantcall][:scale][:workflow]}" do
  user node[:hiway][:user]
  group node[:hadoop][:group]
  source "#{node[:hiway][:variantcall][:scale][:workflow]}.erb"
  mode "755"
  variables({
     :gz => node[:hiway][:variantcall][:scale][:gz],
  })
end

node[:hiway][:variantcall][:scale][:gz].each do |sample, runs|
  # create reads directory
  directory "#{node[:hiway][:data]}/#{sample}" do
    owner node[:hiway][:user]
    group node[:hadoop][:group]
    mode "755"
    action :create
  end
  
  runs.each do |run|
    %w{ 1 2 }.each do |id|
      gz = "#{run}_#{id}.filt.fastq.gz"
      
      remote_file "#{node[:hiway][:data]}/#{sample}/#{gz}" do
        source "#{node[:hiway][:variantcall][:reads][:url_base]}/#{gz}"
        owner node[:hiway][:user]
        group node[:hadoop][:group]
        mode "775"
        action :create_if_missing
      end
    end
  end
  
  # copy input data into HDFS
  bash "copy_input_data_to_hdfs" do
    user node[:hiway][:user]
    group node[:hadoop][:group]
    code <<-EOH
    set -e && set -o pipefail
      #{node[:hadoop][:home]}/bin/hdfs dfs -put #{node[:hiway][:data]}/#{sample} #{node[:hiway][:hiway][:hdfs][:basedir]}/#{sample}
      #rm -r #{node[:hiway][:data]}/#{sample}
    EOH
    not_if "#{node[:hadoop][:home]}/bin/hdfs dfs -test -e #{node[:hiway][:hiway][:hdfs][:basedir]}/#{sample}"
  end
end
