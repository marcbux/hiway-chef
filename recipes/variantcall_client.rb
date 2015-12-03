# install unzip
package "unzip" do
  options "--force-yes"
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

# prepare the variant call workflow file
template "#{node[:saasfee][:workflows]}/#{node[:saasfee][:variantcall][:workflow]}" do
  user node[:saasfee][:user]
  group node[:hadoop][:group]
  source "#{node[:saasfee][:variantcall][:workflow]}.erb"
  mode "755"
  variables({
     :run_ids => node[:saasfee][:variantcall][:reads][:run_ids],
     :chromosomes => node[:saasfee][:variantcall][:reference][:chromosomes],
  })
end

# create reads directory
directory "#{node[:saasfee][:data]}/#{node[:saasfee][:variantcall][:reads][:sample_id]}" do
  owner node[:saasfee][:user]
  group node[:hadoop][:group]
  mode "755"
  action :create
end

# create reads directory in hdfs
hadoop_hdfs_directory "#{node[:saasfee][:hiway][:hdfs][:basedir]}/#{node[:saasfee][:variantcall][:reads][:sample_id]}" do
  action :create_as_superuser
  owner node[:saasfee][:user]
  group node[:saasfee][:group]
  mode "0775"
end

# create reference directory
directory "#{node[:saasfee][:data]}/#{node[:saasfee][:variantcall][:reference][:id]}" do
  owner node[:saasfee][:user]
  group node[:hadoop][:group]
  mode "755"
  action :create
end

# create reference directory in hdfs
hadoop_hdfs_directory "#{node[:saasfee][:hiway][:hdfs][:basedir]}/#{node[:saasfee][:variantcall][:reference][:id]}" do
  action :create_as_superuser
  owner node[:saasfee][:user]
  group node[:saasfee][:group]
  mode "0775"
end

# create annovar database directory
directory "#{node[:saasfee][:data]}/#{node[:saasfee][:variantcall][:annovardb][:directory]}" do
  owner node[:saasfee][:user]
  group node[:hadoop][:group]
  mode "755"
  action :create
end

node[:saasfee][:variantcall][:reads][:run_ids].each do |run_id|
  %w{ 1 2 }.each do |id|
    fq = "#{run_id}_#{id}.filt.fastq"
    gz = "#{fq}.gz"
    
    remote_file "#{Chef::Config[:file_cache_path]}/#{gz}" do
      source "#{node[:saasfee][:variantcall][:reads][:url_base]}/#{gz}"
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
        gzip -c -d "#{Chef::Config[:file_cache_path]}/#{gz}" > "#{node[:saasfee][:data]}/#{node[:saasfee][:variantcall][:reads][:sample_id]}/#{fq}"
      EOH
      not_if { ::File.exists?( "#{node[:saasfee][:data]}/#{node[:saasfee][:variantcall][:reads][:sample_id]}/#{fq}" ) }
    end
    
    # copy reads into HDFS
    bash "copy_reads_to_hdfs" do
      user node[:saasfee][:user]
      group node[:hadoop][:group]
      code <<-EOH
      set -e && set -o pipefail
        #{node[:hadoop][:home]}/bin/hdfs dfs -put #{node[:saasfee][:data]}/#{node[:saasfee][:variantcall][:reads][:sample_id]}/#{fq} #{node[:saasfee][:hiway][:hdfs][:basedir]}/#{node[:saasfee][:variantcall][:reads][:sample_id]}/#{fq}
        rm -r #{node[:saasfee][:data]}/#{node[:saasfee][:variantcall][:reads][:sample_id]}/#{fq}
      EOH
      not_if "#{node[:hadoop][:home]}/bin/hdfs dfs -test -e #{node[:saasfee][:hiway][:hdfs][:basedir]}/#{node[:saasfee][:variantcall][:reads][:sample_id]}/#{fq}"
    end
  end
end

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
      gzip -c -d "#{Chef::Config[:file_cache_path]}/#{gz}" > "#{node[:saasfee][:data]}/#{node[:saasfee][:variantcall][:reference][:id]}/#{fa}"
    EOH
    not_if { ::File.exists?( "#{node[:saasfee][:data]}/#{node[:saasfee][:variantcall][:reference][:id]}/#{fa}" ) }
  end
  
  # copy reference into HDFS
  bash "copy_reference_to_hdfs" do
    user node[:saasfee][:user]
    group node[:hadoop][:group]
    code <<-EOH
    set -e && set -o pipefail
      #{node[:hadoop][:home]}/bin/hdfs dfs -put #{node[:saasfee][:data]}/#{node[:saasfee][:variantcall][:reference][:id]}/#{fa} #{node[:saasfee][:hiway][:hdfs][:basedir]}/#{node[:saasfee][:variantcall][:reference][:id]}/#{fa}
      rm -r #{node[:saasfee][:data]}/#{node[:saasfee][:variantcall][:reference][:id]}/#{fa}
    EOH
    not_if "#{node[:hadoop][:home]}/bin/hdfs dfs -test -e #{node[:saasfee][:hiway][:hdfs][:basedir]}/#{node[:saasfee][:variantcall][:reference][:id]}/#{fa}"
  end
end

# obtain annovar db input data
bash 'download_input_data' do
  user node[:saasfee][:user]
  group node[:hadoop][:group]
  code <<-EOH
  set -e
    annotate_variation.pl -downdb -webfrom annovar refGene -buildver "#{node[:saasfee][:variantcall][:reference][:id]}" "#{node[:saasfee][:data]}/#{node[:saasfee][:variantcall][:annovardb][:directory]}/db/"
    tar cf "#{node[:saasfee][:data]}/#{node[:saasfee][:variantcall][:annovardb][:directory]}/#{node[:saasfee][:variantcall][:annovardb][:file]}" -C "#{node[:saasfee][:data]}/#{node[:saasfee][:variantcall][:annovardb][:directory]}" db
  EOH
  not_if { ::File.exists?( "#{node[:saasfee][:data]}/#{node[:saasfee][:variantcall][:annovardb][:directory]}/#{node[:saasfee][:variantcall][:annovardb][:file]}" ) }
end

# copy annovar db into HDFS
bash "copy_annovardb_to_hdfs" do
  user node[:saasfee][:user]
  group node[:hadoop][:group]
  code <<-EOH
  set -e && set -o pipefail
    #{node[:hadoop][:home]}/bin/hdfs dfs -put #{node[:saasfee][:data]}/#{node[:saasfee][:variantcall][:annovardb][:directory]} #{node[:saasfee][:hiway][:hdfs][:basedir]}/#{node[:saasfee][:variantcall][:annovardb][:directory]}
    rm -r #{node[:saasfee][:data]}/#{node[:saasfee][:variantcall][:annovardb][:directory]}
  EOH
  not_if "#{node[:hadoop][:home]}/bin/hdfs dfs -test -e #{node[:saasfee][:hiway][:hdfs][:basedir]}/#{node[:saasfee][:variantcall][:annovardb][:directory]}"
end
