# update tool shed: install fastq_trimmer_by_quality
bash "update_tool_shed" do
  user node[:hiway][:user]
  group node[:hadoop][:group]
  environment "PYTHON_EGG_CACHE" => "#{node[:hiway][:home]}/.python-eggs"
  code <<-EOH
  set -e && set -o pipefail
    #{node[:hiway][:galaxy][:home]}/scripts/api/install_tool_shed_repositories.py --url http://toolshed.g2.bx.psu.edu/ --api `cat #{node[:hiway][:galaxy][:home]}/api` --local http://localhost:8080/ --name #{node[:hiway][:RNASeq][:fastq_trimmer_by_quality][:name]} --owner devteam --revision #{node[:hiway][:RNASeq][:fastq_trimmer_by_quality][:revision]} --repository-deps --tool-deps --panel-section-name RNAseq
  EOH
  not_if { ::File.exists?( "#{node[:hiway][:software][:dir]}/shed_tools/toolshed.g2.bx.psu.edu/repos/devteam/#{node[:hiway][:RNASeq][:fastq_trimmer_by_quality][:name]}" ) }
end

# update tool shed: install fastqc
bash "update_tool_shed" do
  user node[:hiway][:user]
  group node[:hadoop][:group]
  environment "PYTHON_EGG_CACHE" => "#{node[:hiway][:home]}/.python-eggs"
  code <<-EOH
  set -e && set -o pipefail
    #{node[:hiway][:galaxy][:home]}/scripts/api/install_tool_shed_repositories.py --url http://toolshed.g2.bx.psu.edu/ --api `cat #{node[:hiway][:galaxy][:home]}/api` --local http://localhost:8080/ --name #{node[:hiway][:RNASeq][:fastqc][:name]} --owner devteam --revision #{node[:hiway][:RNASeq][:fastqc][:revision]} --repository-deps --tool-deps --panel-section-name RNAseq
  EOH
  not_if { ::File.exists?( "#{node[:hiway][:software][:dir]}/shed_tools/toolshed.g2.bx.psu.edu/repos/devteam/#{node[:hiway][:RNASeq][:fastqc][:name]}" ) }
end

# update tool shed: install fastx_clipper
bash "update_tool_shed" do
  user node[:hiway][:user]
  group node[:hadoop][:group]
  environment "PYTHON_EGG_CACHE" => "#{node[:hiway][:home]}/.python-eggs"
  code <<-EOH
  set -e && set -o pipefail
    #{node[:hiway][:galaxy][:home]}/scripts/api/install_tool_shed_repositories.py --url http://toolshed.g2.bx.psu.edu/ --api `cat #{node[:hiway][:galaxy][:home]}/api` --local http://localhost:8080/ --name #{node[:hiway][:RNASeq][:fastx_clipper][:name]} --owner devteam --revision #{node[:hiway][:RNASeq][:fastx_clipper][:revision]} --repository-deps --tool-deps --panel-section-name RNAseq
  EOH
  not_if { ::File.exists?( "#{node[:hiway][:software][:dir]}/shed_tools/toolshed.g2.bx.psu.edu/repos/devteam/#{node[:hiway][:RNASeq][:fastx_clipper][:name]}" ) }
end

# update tool shed: install tophat2
bash "update_tool_shed" do
  user node[:hiway][:user]
  group node[:hadoop][:group]
  environment "PYTHON_EGG_CACHE" => "#{node[:hiway][:home]}/.python-eggs"
  code <<-EOH
  set -e && set -o pipefail
    #{node[:hiway][:galaxy][:home]}/scripts/api/install_tool_shed_repositories.py --url http://toolshed.g2.bx.psu.edu/ --api `cat #{node[:hiway][:galaxy][:home]}/api` --local http://localhost:8080/ --name #{node[:hiway][:RNASeq][:tophat2][:name]} --owner devteam --revision #{node[:hiway][:RNASeq][:tophat2][:revision]} --repository-deps --tool-deps --panel-section-name RNAseq
  EOH
  not_if { ::File.exists?( "#{node[:hiway][:software][:dir]}/shed_tools/toolshed.g2.bx.psu.edu/repos/devteam/#{node[:hiway][:RNASeq][:tophat2][:name]}" ) }
end

# update tool shed: install picard
bash "update_tool_shed" do
  user node[:hiway][:user]
  group node[:hadoop][:group]
  environment "PYTHON_EGG_CACHE" => "#{node[:hiway][:home]}/.python-eggs"
  code <<-EOH
  set -e && set -o pipefail
    #{node[:hiway][:galaxy][:home]}/scripts/api/install_tool_shed_repositories.py --url http://toolshed.g2.bx.psu.edu/ --api `cat #{node[:hiway][:galaxy][:home]}/api` --local http://localhost:8080/ --name #{node[:hiway][:RNASeq][:picard][:name]} --owner devteam --revision #{node[:hiway][:RNASeq][:picard][:revision]} --repository-deps --tool-deps --panel-section-name RNAseq
  EOH
  not_if { ::File.exists?( "#{node[:hiway][:software][:dir]}/shed_tools/toolshed.g2.bx.psu.edu/repos/devteam/#{node[:hiway][:RNASeq][:picard][:name]}" ) }
end

# update tool shed: install cufflinks
bash "update_tool_shed" do
  user node[:hiway][:user]
  group node[:hadoop][:group]
  environment "PYTHON_EGG_CACHE" => "#{node[:hiway][:home]}/.python-eggs"
  code <<-EOH
  set -e && set -o pipefail
    #{node[:hiway][:galaxy][:home]}/scripts/api/install_tool_shed_repositories.py --url http://toolshed.g2.bx.psu.edu/ --api `cat #{node[:hiway][:galaxy][:home]}/api` --local http://localhost:8080/ --name #{node[:hiway][:RNASeq][:cufflinks][:name]} --owner devteam --revision #{node[:hiway][:RNASeq][:cufflinks][:revision]} --repository-deps --tool-deps --panel-section-name RNAseq
  EOH
  not_if { ::File.exists?( "#{node[:hiway][:software][:dir]}/shed_tools/toolshed.g2.bx.psu.edu/repos/devteam/#{node[:hiway][:RNASeq][:cufflinks][:name]}" ) }
end

# update tool shed: install cuffmerge
bash "update_tool_shed" do
  user node[:hiway][:user]
  group node[:hadoop][:group]
  environment "PYTHON_EGG_CACHE" => "#{node[:hiway][:home]}/.python-eggs"
  code <<-EOH
  set -e && set -o pipefail
    #{node[:hiway][:galaxy][:home]}/scripts/api/install_tool_shed_repositories.py --url http://toolshed.g2.bx.psu.edu/ --api `cat #{node[:hiway][:galaxy][:home]}/api` --local http://localhost:8080/ --name #{node[:hiway][:RNASeq][:cuffmerge][:name]} --owner devteam --revision #{node[:hiway][:RNASeq][:cuffmerge][:revision]} --repository-deps --tool-deps --panel-section-name RNAseq
  EOH
  not_if { ::File.exists?( "#{node[:hiway][:software][:dir]}/shed_tools/toolshed.g2.bx.psu.edu/repos/devteam/#{node[:hiway][:RNASeq][:cuffmerge][:name]}" ) }
end

# update tool shed: install cuffcompare
bash "update_tool_shed" do
  user node[:hiway][:user]
  group node[:hadoop][:group]
  environment "PYTHON_EGG_CACHE" => "#{node[:hiway][:home]}/.python-eggs"
  code <<-EOH
  set -e && set -o pipefail
    #{node[:hiway][:galaxy][:home]}/scripts/api/install_tool_shed_repositories.py --url http://toolshed.g2.bx.psu.edu/ --api `cat #{node[:hiway][:galaxy][:home]}/api` --local http://localhost:8080/ --name #{node[:hiway][:RNASeq][:cuffcompare][:name]} --owner devteam --revision #{node[:hiway][:RNASeq][:cuffcompare][:revision]} --repository-deps --tool-deps --panel-section-name RNAseq
  EOH
  not_if { ::File.exists?( "#{node[:hiway][:software][:dir]}/shed_tools/toolshed.g2.bx.psu.edu/repos/devteam/#{node[:hiway][:RNASeq][:cuffcompare][:name]}" ) }
end

# update tool shed: install cuffdiff
bash "update_tool_shed" do
  user node[:hiway][:user]
  group node[:hadoop][:group]
  environment "PYTHON_EGG_CACHE" => "#{node[:hiway][:home]}/.python-eggs"
  code <<-EOH
  set -e && set -o pipefail
    #{node[:hiway][:galaxy][:home]}/scripts/api/install_tool_shed_repositories.py --url http://toolshed.g2.bx.psu.edu/ --api `cat #{node[:hiway][:galaxy][:home]}/api` --local http://localhost:8080/ --name #{node[:hiway][:RNASeq][:cuffdiff][:name]} --owner devteam --revision #{node[:hiway][:RNASeq][:cuffdiff][:revision]} --repository-deps --tool-deps --panel-section-name RNAseq
  EOH
  not_if { ::File.exists?( "#{node[:hiway][:software][:dir]}/shed_tools/toolshed.g2.bx.psu.edu/repos/devteam/#{node[:hiway][:RNASeq][:cuffdiff][:name]}" ) }
end

# update tool shed: install column_maker
bash "update_tool_shed" do
  user node[:hiway][:user]
  group node[:hadoop][:group]
  environment "PYTHON_EGG_CACHE" => "#{node[:hiway][:home]}/.python-eggs"
  code <<-EOH
  set -e && set -o pipefail
    #{node[:hiway][:galaxy][:home]}/scripts/api/install_tool_shed_repositories.py --url http://toolshed.g2.bx.psu.edu/ --api `cat #{node[:hiway][:galaxy][:home]}/api` --local http://localhost:8080/ --name #{node[:hiway][:RNASeq][:column_maker][:name]} --owner devteam --revision #{node[:hiway][:RNASeq][:column_maker][:revision]} --repository-deps --tool-deps --panel-section-name RNAseq
  EOH
  not_if { ::File.exists?( "#{node[:hiway][:software][:dir]}/shed_tools/toolshed.g2.bx.psu.edu/repos/devteam/#{node[:hiway][:RNASeq][:column_maker][:name]}" ) }
end

# create indices directory
directory "#{node[:hiway][:galaxy][:home]}/indices" do
  owner node[:hiway][:user]
  group node[:hadoop][:group]
  mode "755"
  action :create
end

# download and register bowtie 2 index mm9
bash "download_bowtie2_index" do
  user node[:hiway][:user]
  group node[:hadoop][:group]
  environment "PYTHON_EGG_CACHE" => "#{node[:hiway][:home]}/.python-eggs"
  code <<-EOH
  set -e && set -o pipefail
    rsync -avzP rsync://datacache.g2.bx.psu.edu/indexes/mm9/mm9full/bowtie2_index/*.bt2 #{node[:hiway][:galaxy][:home]}/indices
    rsync -avzP rsync://datacache.g2.bx.psu.edu/indexes/mm9/seq/mm9full.fa #{node[:hiway][:galaxy][:home]}/indices
    echo -e "mm9\\tmm9\\tMouse (Mus musculus): mm9\\t#{node[:hiway][:galaxy][:home]}/indices/mm9full" >> #{node[:hiway][:galaxy][:home]}/tool-data/toolshed.g2.bx.psu.edu/repos/devteam/#{node[:hiway][:RNASeq][:tophat2][:name]}/#{node[:hiway][:RNASeq][:tophat2][:revision]}/bowtie2_indices.loc
  EOH
  not_if "grep -q \"indices/mm9full\" #{node[:hiway][:galaxy][:home]}/tool-data/toolshed.g2.bx.psu.edu/repos/devteam/#{node[:hiway][:RNASeq][:tophat2][:name]}/#{node[:hiway][:RNASeq][:tophat2][:revision]}/bowtie2_indices.loc"
end
