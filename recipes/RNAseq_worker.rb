# update tool shed: install fastq_trimmer_by_quality
bash "intall_fastq_trimmer_by_quality" do
  user node[:saasfee][:user]
  group node[:hadoop][:group]
  environment "PYTHON_EGG_CACHE" => "#{node[:saasfee][:home]}/.python-eggs"
  code <<-EOH
  set -e && set -o pipefail
    #{node[:saasfee][:galaxy][:home]}/scripts/api/install_tool_shed_repositories.py --url http://toolshed.g2.bx.psu.edu/ --api `cat #{node[:saasfee][:galaxy][:home]}/api` --local http://localhost:8080/ --name #{node[:saasfee][:RNAseq][:fastq_trimmer_by_quality][:name]} --owner devteam --revision #{node[:saasfee][:RNAseq][:fastq_trimmer_by_quality][:revision]} --repository-deps --tool-deps --panel-section-name RNAseq
  EOH
  not_if { ::File.exists?( "#{node[:saasfee][:software][:dir]}/shed_tools/toolshed.g2.bx.psu.edu/repos/devteam/#{node[:saasfee][:RNAseq][:fastq_trimmer_by_quality][:name]}" ) }
end

# update tool shed: install fastqc
bash "intall_fastqc" do
  user node[:saasfee][:user]
  group node[:hadoop][:group]
  environment "PYTHON_EGG_CACHE" => "#{node[:saasfee][:home]}/.python-eggs"
  code <<-EOH
  set -e && set -o pipefail
    #{node[:saasfee][:galaxy][:home]}/scripts/api/install_tool_shed_repositories.py --url http://toolshed.g2.bx.psu.edu/ --api `cat #{node[:saasfee][:galaxy][:home]}/api` --local http://localhost:8080/ --name #{node[:saasfee][:RNAseq][:fastqc][:name]} --owner devteam --revision #{node[:saasfee][:RNAseq][:fastqc][:revision]} --repository-deps --tool-deps --panel-section-name RNAseq
  EOH
  not_if { ::File.exists?( "#{node[:saasfee][:software][:dir]}/shed_tools/toolshed.g2.bx.psu.edu/repos/devteam/#{node[:saasfee][:RNAseq][:fastqc][:name]}" ) }
end

# update tool shed: install fastx_clipper
bash "intall_fastx_clipper" do
  user node[:saasfee][:user]
  group node[:hadoop][:group]
  environment "PYTHON_EGG_CACHE" => "#{node[:saasfee][:home]}/.python-eggs"
  code <<-EOH
  set -e && set -o pipefail
    #{node[:saasfee][:galaxy][:home]}/scripts/api/install_tool_shed_repositories.py --url http://toolshed.g2.bx.psu.edu/ --api `cat #{node[:saasfee][:galaxy][:home]}/api` --local http://localhost:8080/ --name #{node[:saasfee][:RNAseq][:fastx_clipper][:name]} --owner devteam --revision #{node[:saasfee][:RNAseq][:fastx_clipper][:revision]} --repository-deps --tool-deps --panel-section-name RNAseq
  EOH
  not_if { ::File.exists?( "#{node[:saasfee][:software][:dir]}/shed_tools/toolshed.g2.bx.psu.edu/repos/devteam/#{node[:saasfee][:RNAseq][:fastx_clipper][:name]}" ) }
end

# update tool shed: install tophat2
bash "intall_tophat2" do
  user node[:saasfee][:user]
  group node[:hadoop][:group]
  environment "PYTHON_EGG_CACHE" => "#{node[:saasfee][:home]}/.python-eggs"
  code <<-EOH
  set -e && set -o pipefail
    #{node[:saasfee][:galaxy][:home]}/scripts/api/install_tool_shed_repositories.py --url http://toolshed.g2.bx.psu.edu/ --api `cat #{node[:saasfee][:galaxy][:home]}/api` --local http://localhost:8080/ --name #{node[:saasfee][:RNAseq][:tophat2][:name]} --owner devteam --revision #{node[:saasfee][:RNAseq][:tophat2][:revision]} --repository-deps --tool-deps --panel-section-name RNAseq
  EOH
  not_if { ::File.exists?( "#{node[:saasfee][:software][:dir]}/shed_tools/toolshed.g2.bx.psu.edu/repos/devteam/#{node[:saasfee][:RNAseq][:tophat2][:name]}" ) }
end

# update tool shed: install picard
bash "intall_picard" do
  user node[:saasfee][:user]
  group node[:hadoop][:group]
  environment "PYTHON_EGG_CACHE" => "#{node[:saasfee][:home]}/.python-eggs"
  code <<-EOH
  set -e && set -o pipefail
    #{node[:saasfee][:galaxy][:home]}/scripts/api/install_tool_shed_repositories.py --url http://toolshed.g2.bx.psu.edu/ --api `cat #{node[:saasfee][:galaxy][:home]}/api` --local http://localhost:8080/ --name #{node[:saasfee][:RNAseq][:picard][:name]} --owner devteam --revision #{node[:saasfee][:RNAseq][:picard][:revision]} --repository-deps --tool-deps --panel-section-name RNAseq
  EOH
  not_if { ::File.exists?( "#{node[:saasfee][:software][:dir]}/shed_tools/toolshed.g2.bx.psu.edu/repos/devteam/#{node[:saasfee][:RNAseq][:picard][:name]}" ) }
end

# update tool shed: install cufflinks
bash "intall_cufflinks" do
  user node[:saasfee][:user]
  group node[:hadoop][:group]
  environment "PYTHON_EGG_CACHE" => "#{node[:saasfee][:home]}/.python-eggs"
  code <<-EOH
  set -e && set -o pipefail
    #{node[:saasfee][:galaxy][:home]}/scripts/api/install_tool_shed_repositories.py --url http://toolshed.g2.bx.psu.edu/ --api `cat #{node[:saasfee][:galaxy][:home]}/api` --local http://localhost:8080/ --name #{node[:saasfee][:RNAseq][:cufflinks][:name]} --owner devteam --revision #{node[:saasfee][:RNAseq][:cufflinks][:revision]} --repository-deps --tool-deps --panel-section-name RNAseq
  EOH
  not_if { ::File.exists?( "#{node[:saasfee][:software][:dir]}/shed_tools/toolshed.g2.bx.psu.edu/repos/devteam/#{node[:saasfee][:RNAseq][:cufflinks][:name]}" ) }
end

# update tool shed: install cuffmerge
bash "intall_cuffmerge" do
  user node[:saasfee][:user]
  group node[:hadoop][:group]
  environment "PYTHON_EGG_CACHE" => "#{node[:saasfee][:home]}/.python-eggs"
  code <<-EOH
  set -e && set -o pipefail
    #{node[:saasfee][:galaxy][:home]}/scripts/api/install_tool_shed_repositories.py --url http://toolshed.g2.bx.psu.edu/ --api `cat #{node[:saasfee][:galaxy][:home]}/api` --local http://localhost:8080/ --name #{node[:saasfee][:RNAseq][:cuffmerge][:name]} --owner devteam --revision #{node[:saasfee][:RNAseq][:cuffmerge][:revision]} --repository-deps --tool-deps --panel-section-name RNAseq
  EOH
  not_if { ::File.exists?( "#{node[:saasfee][:software][:dir]}/shed_tools/toolshed.g2.bx.psu.edu/repos/devteam/#{node[:saasfee][:RNAseq][:cuffmerge][:name]}" ) }
end

# update tool shed: install cuffcompare
bash "intall_cuffcompare" do
  user node[:saasfee][:user]
  group node[:hadoop][:group]
  environment "PYTHON_EGG_CACHE" => "#{node[:saasfee][:home]}/.python-eggs"
  code <<-EOH
  set -e && set -o pipefail
    #{node[:saasfee][:galaxy][:home]}/scripts/api/install_tool_shed_repositories.py --url http://toolshed.g2.bx.psu.edu/ --api `cat #{node[:saasfee][:galaxy][:home]}/api` --local http://localhost:8080/ --name #{node[:saasfee][:RNAseq][:cuffcompare][:name]} --owner devteam --revision #{node[:saasfee][:RNAseq][:cuffcompare][:revision]} --repository-deps --tool-deps --panel-section-name RNAseq
  EOH
  not_if { ::File.exists?( "#{node[:saasfee][:software][:dir]}/shed_tools/toolshed.g2.bx.psu.edu/repos/devteam/#{node[:saasfee][:RNAseq][:cuffcompare][:name]}" ) }
end

# update tool shed: install cuffdiff
bash "intall_cuffdiff" do
  user node[:saasfee][:user]
  group node[:hadoop][:group]
  environment "PYTHON_EGG_CACHE" => "#{node[:saasfee][:home]}/.python-eggs"
  code <<-EOH
  set -e && set -o pipefail
    #{node[:saasfee][:galaxy][:home]}/scripts/api/install_tool_shed_repositories.py --url http://toolshed.g2.bx.psu.edu/ --api `cat #{node[:saasfee][:galaxy][:home]}/api` --local http://localhost:8080/ --name #{node[:saasfee][:RNAseq][:cuffdiff][:name]} --owner devteam --revision #{node[:saasfee][:RNAseq][:cuffdiff][:revision]} --repository-deps --tool-deps --panel-section-name RNAseq
  EOH
  not_if { ::File.exists?( "#{node[:saasfee][:software][:dir]}/shed_tools/toolshed.g2.bx.psu.edu/repos/devteam/#{node[:saasfee][:RNAseq][:cuffdiff][:name]}" ) }
end

# update tool shed: install column_maker
bash "intall_column_maker" do
  user node[:saasfee][:user]
  group node[:hadoop][:group]
  environment "PYTHON_EGG_CACHE" => "#{node[:saasfee][:home]}/.python-eggs"
  code <<-EOH
  set -e && set -o pipefail
    #{node[:saasfee][:galaxy][:home]}/scripts/api/install_tool_shed_repositories.py --url http://toolshed.g2.bx.psu.edu/ --api `cat #{node[:saasfee][:galaxy][:home]}/api` --local http://localhost:8080/ --name #{node[:saasfee][:RNAseq][:column_maker][:name]} --owner devteam --revision #{node[:saasfee][:RNAseq][:column_maker][:revision]} --repository-deps --tool-deps --panel-section-name RNAseq
  EOH
  not_if { ::File.exists?( "#{node[:saasfee][:software][:dir]}/shed_tools/toolshed.g2.bx.psu.edu/repos/devteam/#{node[:saasfee][:RNAseq][:column_maker][:name]}" ) }
end

# create indices directory
directory "#{node[:saasfee][:data]}/indices" do
  owner node[:saasfee][:user]
  group node[:hadoop][:group]
  mode "755"
  action :create
end

# prevent rsync from timing out
bash 'enable_x11_forwarding' do
  user "root"
  code <<-EOH
  set -e && set -o pipefail
    echo "KeepAlive yes" >> /etc/ssh/ssh_config
    echo "ServerAliveInterval 20" >> /etc/ssh/ssh_config
  EOH
  not_if "grep -q \"ServerAliveInterval 20\" /etc/ssh/ssh_config"
end

# download and register bowtie 2 index mm9
bash "download_bowtie2_index" do
  user node[:saasfee][:user]
  group node[:hadoop][:group]
  environment "PYTHON_EGG_CACHE" => "#{node[:saasfee][:home]}/.python-eggs"
  code <<-EOH
  set -e && set -o pipefail
    rsync -avzP rsync://datacache.g2.bx.psu.edu/indexes/mm9/mm9full/bowtie2_index/*.bt2 #{node[:saasfee][:data]}/indices
    rsync -avzP rsync://datacache.g2.bx.psu.edu/indexes/mm9/seq/mm9full.fa #{node[:saasfee][:data]}/indices
    echo -e "mm9\\tmm9\\tMouse (Mus musculus): mm9\\t#{node[:saasfee][:data]}/indices/mm9full" >> #{node[:saasfee][:galaxy][:home]}/tool-data/toolshed.g2.bx.psu.edu/repos/devteam/#{node[:saasfee][:RNAseq][:tophat2][:name]}/#{node[:saasfee][:RNAseq][:tophat2][:revision]}/bowtie2_indices.loc
  EOH
  not_if "grep -q \"indices/mm9full\" #{node[:saasfee][:galaxy][:home]}/tool-data/toolshed.g2.bx.psu.edu/repos/devteam/#{node[:saasfee][:RNAseq][:tophat2][:name]}/#{node[:saasfee][:RNAseq][:tophat2][:revision]}/bowtie2_indices.loc"
end
