# install unzip
package "unzip" do
  options "--force-yes"
end

# download annovar binaries
remote_file "#{Chef::Config[:file_cache_path]}/#{node[:hiway][:variantcall][:annovar][:targz]}" do
  source node[:hiway][:variantcall][:annovar][:url]
  owner node[:hiway][:user]
  group node[:hadoop][:group]
  mode "775"
  action :create_if_missing
end

# install annovar
bash "install_annovar" do
  user node[:hiway][:user]
  group node[:hadoop][:group]
  code <<-EOH
  set -e && set -o pipefail
    tar xvfz #{Chef::Config[:file_cache_path]}/#{node[:hiway][:variantcall][:annovar][:targz]} -C #{node[:hiway][:software][:dir]}
  EOH
  not_if { ::File.exist?("#{node[:hiway][:variantcall][:annovar][:home]}") }
end

# add annovar executables to /usr/bin
bash 'update_env_variables' do
  user "root"
  code <<-EOH
  set -e && set -o pipefail
    ln -s #{node[:hiway][:variantcall][:annovar][:home]}/*.pl /usr/bin/
  EOH
  not_if { ::File.exist?("/usr/bin/annotate_variation.pl") }
end

# prepare the variant call workflow file
template "#{node[:hiway][:data]}/#{node[:hiway][:variantcall][:workflow]}" do
  user node[:hiway][:user]
  group node[:hadoop][:group]
  source "#{node[:hiway][:variantcall][:workflow]}.erb"
  mode "755"
  variables({
     :run_ids => node[:hiway][:variantcall][:reads][:run_ids],
     :chromosomes => node[:hiway][:variantcall][:reference][:chromosomes],
  })
end

# create reads directory
directory "#{node[:hiway][:data]}/#{node[:hiway][:variantcall][:reads][:sample_id]}" do
  owner node[:hiway][:user]
  group node[:hadoop][:group]
  mode "755"
  action :create
end

# create reference directory
directory "#{node[:hiway][:data]}/#{node[:hiway][:variantcall][:reference][:id]}" do
  owner node[:hiway][:user]
  group node[:hadoop][:group]
  mode "755"
  action :create
end

# create annovar database directory
directory "#{node[:hiway][:data]}/#{node[:hiway][:variantcall][:annovardb][:directory]}" do
  owner node[:hiway][:user]
  group node[:hadoop][:group]
  mode "755"
  action :create
end

node[:hiway][:variantcall][:reads][:run_ids].each do |run_id|
  %w{ 1 2 }.each do |id|
    fq = "#{run_id}_#{id}.filt.fastq"
    gz = "#{fq}.gz"
    
    remote_file "#{Chef::Config[:file_cache_path]}/#{gz}" do
      source "#{node[:hiway][:variantcall][:reads][:url_base]}/#{gz}"
      owner node[:hiway][:user]
      group node[:hadoop][:group]
      mode "775"
      action :create_if_missing
    end
    
    bash 'extract' do
      user node[:hiway][:user]
      group node[:hadoop][:group]
      code <<-EOH
      set -e
        gzip -c -d "#{Chef::Config[:file_cache_path]}/#{gz}" > "#{node[:hiway][:data]}/#{node[:hiway][:variantcall][:reads][:sample_id]}/#{fq}"
      EOH
      not_if { ::File.exists?( "#{node[:hiway][:data]}/#{node[:hiway][:variantcall][:reads][:sample_id]}/#{fq}" ) }
    end
  end
end

node[:hiway][:variantcall][:reference][:chromosomes].each do |ref|
  fa = "#{ref}.fa"
  gz = "#{fa}.gz"
  
  remote_file "#{Chef::Config[:file_cache_path]}/#{gz}" do
    source "#{node[:hiway][:variantcall][:reference][:url_base]}/#{gz}"
    owner node[:hiway][:user]
    group node[:hadoop][:group]
    mode "775"
    action :create_if_missing
  end
  
  bash 'extract' do
    user node[:hiway][:user]
    group node[:hadoop][:group]
    code <<-EOH
    set -e
      gzip -c -d "#{Chef::Config[:file_cache_path]}/#{gz}" > "#{node[:hiway][:data]}/#{node[:hiway][:variantcall][:reference][:id]}/#{fa}"
    EOH
    not_if { ::File.exists?( "#{node[:hiway][:data]}/#{node[:hiway][:variantcall][:reference][:id]}/#{fa}" ) }
  end
end

# obtain workflow input data
bash 'download_input_data' do
  user node[:hiway][:user]
  group node[:hadoop][:group]
  code <<-EOH
  set -e
    annotate_variation.pl -downdb -webfrom annovar refGene -buildver "#{node[:hiway][:variantcall][:reference][:id]}" "#{node[:hiway][:data]}/#{node[:hiway][:variantcall][:annovardb][:directory]}/db/"
    tar cf "#{node[:hiway][:data]}/#{node[:hiway][:variantcall][:annovardb][:directory]}/#{node[:hiway][:variantcall][:annovardb][:file]}" -C "#{node[:hiway][:data]}/#{node[:hiway][:variantcall][:annovardb][:directory]}" db
  EOH
  not_if { ::File.exists?( "#{node[:hiway][:data]}/#{node[:hiway][:variantcall][:annovardb][:directory]}/#{node[:hiway][:variantcall][:annovardb][:file]}" ) }
end

# copy input data into HDFS
bash "copy_input_data_to_hdfs" do
  user node[:hiway][:user]
  group node[:hadoop][:group]
  code <<-EOH
  set -e && set -o pipefail
    #{node[:hadoop][:home]}/bin/hdfs dfs -put #{node[:hiway][:data]}/#{node[:hiway][:variantcall][:annovardb][:directory]} #{node[:hiway][:hiway][:hdfs][:basedir]}/#{node[:hiway][:variantcall][:annovardb][:directory]}
    #{node[:hadoop][:home]}/bin/hdfs dfs -put #{node[:hiway][:data]}/#{node[:hiway][:variantcall][:reads][:sample_id]} #{node[:hiway][:hiway][:hdfs][:basedir]}/#{node[:hiway][:variantcall][:reads][:sample_id]}
    #{node[:hadoop][:home]}/bin/hdfs dfs -put #{node[:hiway][:data]}/#{node[:hiway][:variantcall][:reference][:id]} #{node[:hiway][:hiway][:hdfs][:basedir]}/#{node[:hiway][:variantcall][:reference][:id]}
    rm -r #{node[:hiway][:data]}/#{node[:hiway][:variantcall][:annovardb][:directory]}
    rm -r #{node[:hiway][:data]}/#{node[:hiway][:variantcall][:reads][:sample_id]}
    rm -r #{node[:hiway][:data]}/#{node[:hiway][:variantcall][:reference][:id]}
  EOH
  not_if "#{node[:hadoop][:home]}/bin/hdfs dfs -test -e /#{node[:hiway][:variantcall][:reference][:id]}"
end
