# prepare the variant call workflow file
template "#{node[:saasfee][:workflows]}/#{node[:saasfee][:variantcall][:scale][:workflow]}" do
  user node[:saasfee][:user]
  group node[:hadoop][:group]
  source "#{node[:saasfee][:variantcall][:scale][:workflow]}.erb"
  mode "755"
  variables({
     :gz => node[:saasfee][:variantcall][:scale][:gz],
  })
end

node[:saasfee][:variantcall][:scale][:gz].each do |sample, runs|
  # create reads directory
  directory "#{node[:saasfee][:data]}/#{sample}" do
    owner node[:saasfee][:user]
    group node[:hadoop][:group]
    mode "755"
    action :create
  end
  
  # create reads directory in hdfs
  hadoop_hdfs_directory "#{node[:saasfee][:hiway][:hdfs][:basedir]}/#{sample}" do
    action :create_as_superuser
    owner node[:saasfee][:user]
    group node[:saasfee][:group]
    mode "0775"
  end
  
  runs.each do |run|
    %w{ 1 2 }.each do |id|
      gz = "#{run}_#{id}.filt.fastq.gz"
      
      remote_file "#{node[:saasfee][:data]}/#{sample}/#{gz}" do
        source "#{node[:saasfee][:variantcall][:reads][:url_base]}/#{gz}"
        owner node[:saasfee][:user]
        group node[:hadoop][:group]
        mode "775"
        action :create_if_missing
      end
      
      # copy input data into HDFS
      bash "copy_input_data_to_hdfs" do
        user node[:saasfee][:user]
        group node[:hadoop][:group]
        code <<-EOH
        set -e && set -o pipefail
          #{node[:hadoop][:home]}/bin/hdfs dfs -put #{node[:saasfee][:data]}/#{sample}/#{gz} #{node[:saasfee][:hiway][:hdfs][:basedir]}/#{sample}/#{gz}
          #rm -r #{node[:saasfee][:data]}/#{sample}/#{gz}
        EOH
        not_if "#{node[:hadoop][:home]}/bin/hdfs dfs -test -e #{node[:saasfee][:hiway][:hdfs][:basedir]}/#{sample}/#{gz}"
      end
    end
  end
end
