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
template "#{node[:hiway][:home]}/#{node[:hiway][:variantcall][:workflow]}" do
  user node[:hiway][:user]
  group node[:hadoop][:group]
  source "#{node[:hiway][:variantcall][:workflow]}.erb"
  mode "755"
end

# create reads directory
directory "#{node[:hiway][:home]}/#{node[:hiway][:variantcall][:reads][:directory]}" do
  owner node[:hiway][:user]
  group node[:hadoop][:group]
  mode "755"
  action :create
end

# create reference directory
directory "#{node[:hiway][:home]}/#{node[:hiway][:variantcall][:reference][:directory]}" do
  owner node[:hiway][:user]
  group node[:hadoop][:group]
  mode "755"
  action :create
end

# create annovar database directory
directory "#{node[:hiway][:home]}/#{node[:hiway][:variantcall][:annovardb][:directory]}" do
  owner node[:hiway][:user]
  group node[:hadoop][:group]
  mode "755"
  action :create
end

# obtain workflow input data
bash 'download_input_data' do
  user node[:hiway][:user]
  group node[:hadoop][:group]
  code <<-EOH
  set -e
    wget -q -O - "#{node[:hiway][:variantcall][:reads][:url]}/#{node[:hiway][:variantcall][:reads][:gz1]}" | gzip -cd | head -n #{node[:hiway][:variantcall][:reads][:lines]} > #{node[:hiway][:home]}/#{node[:hiway][:variantcall][:reads][:directory]}/#{node[:hiway][:variantcall][:reads][:file1]}
    wget -q -O - "#{node[:hiway][:variantcall][:reads][:url]}/#{node[:hiway][:variantcall][:reads][:gz2]}" | gzip -cd | head -n #{node[:hiway][:variantcall][:reads][:lines]} > #{node[:hiway][:home]}/#{node[:hiway][:variantcall][:reads][:directory]}/#{node[:hiway][:variantcall][:reads][:file2]}
    wget -q -O - "#{node[:hiway][:variantcall][:reference][:url]}/#{node[:hiway][:variantcall][:reference][:gz1]}" | gzip -cd > #{node[:hiway][:home]}/#{node[:hiway][:variantcall][:reference][:directory]}/#{node[:hiway][:variantcall][:reference][:file1]}
    wget -q -O - "#{node[:hiway][:variantcall][:reference][:url]}/#{node[:hiway][:variantcall][:reference][:gz2]}" | gzip -cd > #{node[:hiway][:home]}/#{node[:hiway][:variantcall][:reference][:directory]}/#{node[:hiway][:variantcall][:reference][:file2]}
    annotate_variation.pl -downdb -webfrom annovar refGene -buildver hg38 "#{node[:hiway][:home]}/#{node[:hiway][:variantcall][:annovardb][:directory]}/db/"
    tar cf "#{node[:hiway][:home]}/#{node[:hiway][:variantcall][:annovardb][:directory]}/#{node[:hiway][:variantcall][:annovardb][:file]}" -C "#{node[:hiway][:home]}/#{node[:hiway][:variantcall][:annovardb][:directory]}" db
  EOH
  not_if { ::File.exists?( "#{node[:hiway][:home]}/#{node[:hiway][:variantcall][:annovardb][:directory]}/#{node[:hiway][:variantcall][:annovardb][:file]}" ) }
end

# copy input data into HDFS
bash "copy_input_data_to_hdfs" do
  user node[:hiway][:user]
  group node[:hadoop][:group]
  code <<-EOH
  set -e && set -o pipefail
    #{node[:hadoop][:home]}/bin/hdfs dfs -put #{node[:hiway][:home]}/#{node[:hiway][:variantcall][:annovardb][:directory]} #{node[:hiway][:hiway][:hdfs][:basedir]}
    #{node[:hadoop][:home]}/bin/hdfs dfs -put #{node[:hiway][:home]}/#{node[:hiway][:variantcall][:reads][:directory]} #{node[:hiway][:hiway][:hdfs][:basedir]}
    #{node[:hadoop][:home]}/bin/hdfs dfs -put #{node[:hiway][:home]}/#{node[:hiway][:variantcall][:reference][:directory]} #{node[:hiway][:hiway][:hdfs][:basedir]}
    rm -r #{node[:hiway][:home]}/#{node[:hiway][:variantcall][:annovardb][:directory]}
    rm -r #{node[:hiway][:home]}/#{node[:hiway][:variantcall][:reads][:directory]}
    rm -r #{node[:hiway][:home]}/#{node[:hiway][:variantcall][:reference][:directory]}
  EOH
  not_if "#{node[:hadoop][:home]}/bin/hdfs dfs -test -e #{node[:hiway][:home]}/#{node[:hiway][:variantcall][:reference][:directory]}"
end
