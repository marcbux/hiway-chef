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
template "#{node[:hiway][:home]}/#{node[:hiway][:variantcall][:hg38][:workflow]}" do
  user node[:hiway][:user]
  group node[:hadoop][:group]
  source "#{node[:hiway][:variantcall][:hg38][:workflow]}.erb"
  mode "755"
end

# create reads directory
directory "#{node[:hiway][:home]}/#{node[:hiway][:variantcall][:hg38][:reads][:directory]}" do
  owner node[:hiway][:user]
  group node[:hadoop][:group]
  mode "755"
  action :create
  recursive true
end

# create reference directory
directory "#{node[:hiway][:home]}/#{node[:hiway][:variantcall][:hg38][:reference][:directory]}" do
  owner node[:hiway][:user]
  group node[:hadoop][:group]
  mode "755"
  action :create
  recursive true
end

# create annovar database directory
directory "#{node[:hiway][:home]}/#{node[:hiway][:variantcall][:hg38][:annovardb][:directory]}" do
  owner node[:hiway][:user]
  group node[:hadoop][:group]
  mode "755"
  action :create
  recursive true
end

# obtain workflow input data
bash 'download_input_data' do
  user node[:hiway][:user]
  group node[:hadoop][:group]
  code <<-EOH
  set -e
    wget -q -O - "#{node[:hiway][:variantcall][:hg38][:reads][:url]}/#{node[:hiway][:variantcall][:hg38][:reads][:gz1]}" | gzip -cd | head -n #{node[:hiway][:variantcall][:hg38][:reads][:lines]} > #{node[:hiway][:home]}/#{node[:hiway][:variantcall][:hg38][:reads][:directory]}/#{node[:hiway][:variantcall][:hg38][:reads][:file1]}
    wget -q -O - "#{node[:hiway][:variantcall][:hg38][:reads][:url]}/#{node[:hiway][:variantcall][:hg38][:reads][:gz2]}" | gzip -cd | head -n #{node[:hiway][:variantcall][:hg38][:reads][:lines]} > #{node[:hiway][:home]}/#{node[:hiway][:variantcall][:hg38][:reads][:directory]}/#{node[:hiway][:variantcall][:hg38][:reads][:file2]}
    wget -q -O - "#{node[:hiway][:variantcall][:hg38][:reference][:url]}/#{node[:hiway][:variantcall][:hg38][:reference][:gz1]}" | gzip -cd > #{node[:hiway][:home]}/#{node[:hiway][:variantcall][:hg38][:reference][:directory]}/#{node[:hiway][:variantcall][:hg38][:reference][:file1]}
    wget -q -O - "#{node[:hiway][:variantcall][:hg38][:reference][:url]}/#{node[:hiway][:variantcall][:hg38][:reference][:gz2]}" | gzip -cd > #{node[:hiway][:home]}/#{node[:hiway][:variantcall][:hg38][:reference][:directory]}/#{node[:hiway][:variantcall][:hg38][:reference][:file2]}
    annotate_variation.pl -downdb -webfrom annovar refGene -buildver hg38 "#{node[:hiway][:home]}/#{node[:hiway][:variantcall][:hg38][:annovardb][:directory]}/db/"
    tar cf "#{node[:hiway][:home]}/#{node[:hiway][:variantcall][:hg38][:annovardb][:directory]}/#{node[:hiway][:variantcall][:hg38][:annovardb][:file]}" -C "#{node[:hiway][:home]}/#{node[:hiway][:variantcall][:hg38][:annovardb][:directory]}" db
  EOH
  not_if { ::File.exists?( "#{node[:hiway][:home]}/#{node[:hiway][:variantcall][:hg38][:annovardb][:directory]}/#{node[:hiway][:variantcall][:hg38][:annovardb][:file]}" ) }
end

# copy input data into HDFS
bash "copy_input_data_to_hdfs" do
  user node[:hiway][:user]
  group node[:hadoop][:group]
  code <<-EOH
  set -e && set -o pipefail
    #{node[:hadoop][:home]}/bin/hdfs dfs -put #{node[:hiway][:home]}/#{node[:hiway][:variantcall][:hg38][:annovardb][:directory]} #{node[:hiway][:hiway][:hdfs][:basedir]}
    #{node[:hadoop][:home]}/bin/hdfs dfs -put #{node[:hiway][:home]}/#{node[:hiway][:variantcall][:hg38][:reads][:directory]} #{node[:hiway][:hiway][:hdfs][:basedir]}
    #{node[:hadoop][:home]}/bin/hdfs dfs -put #{node[:hiway][:home]}/#{node[:hiway][:variantcall][:hg38][:reference][:directory]} #{node[:hiway][:hiway][:hdfs][:basedir]}
  EOH
  not_if "#{node[:hadoop][:home]}/bin/hdfs dfs -test -e #{node[:hiway][:home]}/#{node[:hiway][:variantcall][:hg38][:reference][:directory]}"
end
