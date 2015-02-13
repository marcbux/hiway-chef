package "mercurial" do
  options "--force-yes"
end

package "curl" do
  options "--force-yes"
end

package "python-dev" do
  options "--force-yes"
end

package "python-cheetah" do
  options "--force-yes"
end

bash "install_galaxy" do
  user node[:hiway][:user]
  group node[:hadoop][:group]
  code <<-EOF
  set -e && set -o pipefail
    hg clone #{node[:hiway][:galaxy][:repository]} #{node[:hiway][:galaxy][:home]}
    hg update stable #{node[:hiway][:galaxy][:home]}
    cp #{node[:hiway][:galaxy][:home]}/config/galaxy.ini.sample #{node[:hiway][:galaxy][:home]}/config/galaxy.ini
    sed -i 's/#master_api_key = changethis/master_api_key = #{node[:hiway][:galaxy][:master_api_key]}/g' #{node[:hiway][:galaxy][:home]}/config/galaxy.ini
    sed -i 's/#admin_users = None/admin_users = #{node[:hiway][:galaxy][:admin_users]}/g' #{node[:hiway][:galaxy][:home]}/config/galaxy.ini
    sed -i 's/#tool_dependency_dir = None/tool_dependency_dir = dependencies/g' #{node[:hiway][:galaxy][:home]}/config/galaxy.ini
  EOF
    not_if { ::File.exists?( "#{node[:hiway][:galaxy][:home]}" ) }
end

service "galaxy" do
  supports :restart => true
  start_command "sh #{node[:hiway][:galaxy][:home]}/run.sh --daemon"
  stop_command "sh #{node[:hiway][:galaxy][:home]}/run.sh --stop-daemon"
  action :start
end

#cp #{node[:hiway][:galaxy][:home]}/config/tool_conf.xml.sample #{node[:hiway][:galaxy][:home]}/config/tool_conf.xml
#cp #{node[:hiway][:galaxy][:home]}/config/shed_tool_conf.xml #{node[:hiway][:galaxy][:home]}/shed_tool_conf.xml   
#curl --data "username=hiway&password=reverse&email=hiway@hiway.com" http://localhost:8080/api/users?key=reverse | grep "id" | sed 's/[\",]//g' | sed 's/id: //' > #{node[:hiway][:galaxy][:home]}/id
#curl -X POST http://localhost:8080/api/users/$id/api_key?key=reverse | sed 's/\"//g' > #{node[:hiway][:galaxy][:home]}/api

#{node[:hiway][:galaxy][:home]}/scripts/api/install_tool_shed_repositories.py --url http://toolshed.g2.bx.psu.edu/ --api `echo #{node[:hiway][:galaxy][:home]}/api` --local http://localhost:8080/ --name join --owner devteam --revision de21bdbb8d28 --repository-deps --tool-deps --panel-section-name galaxy101
#{node[:hiway][:galaxy][:home]}/scripts/api/install_tool_shed_repositories.py --url http://toolshed.g2.bx.psu.edu/ --api `echo #{node[:hiway][:galaxy][:home]}/api` --local http://localhost:8080/ --name fastq_trimmer_by_quality --owner devteam --revision 1cdcaf5fc1da --repository-deps --tool-deps --panel-section-name RNAseq
#{node[:hiway][:galaxy][:home]}/scripts/api/install_tool_shed_repositories.py --url http://toolshed.g2.bx.psu.edu/ --api `echo #{node[:hiway][:galaxy][:home]}/api` --local http://localhost:8080/ --name fastqc --owner devteam --revision e28c965eeed4 --repository-deps --tool-deps --panel-section-name RNAseq
#{node[:hiway][:galaxy][:home]}/scripts/api/install_tool_shed_repositories.py --url http://toolshed.g2.bx.psu.edu/ --api `echo #{node[:hiway][:galaxy][:home]}/api` --local http://localhost:8080/ --name fastx_clipper --owner devteam --revision 8192b4014977 --repository-deps --tool-deps --panel-section-name RNAseq
#{node[:hiway][:galaxy][:home]}/scripts/api/install_tool_shed_repositories.py --url http://toolshed.g2.bx.psu.edu/ --api `echo #{node[:hiway][:galaxy][:home]}/api` --local http://localhost:8080/ --name tophat2 --owner devteam --revision ae06af1118dc --repository-deps --tool-deps --panel-section-name RNAseq
#{node[:hiway][:galaxy][:home]}/scripts/api/install_tool_shed_repositories.py --url http://toolshed.g2.bx.psu.edu/ --api `echo #{node[:hiway][:galaxy][:home]}/api` --local http://localhost:8080/ --name picard --owner devteam --revision ab1f60c26526 --repository-deps --tool-deps --panel-section-name RNAseq
#{node[:hiway][:galaxy][:home]}/scripts/api/install_tool_shed_repositories.py --url http://toolshed.g2.bx.psu.edu/ --api `echo #{node[:hiway][:galaxy][:home]}/api` --local http://localhost:8080/ --name cufflinks --owner devteam --revision 9aab29e159a7 --repository-deps --tool-deps --panel-section-name RNAseq
#{node[:hiway][:galaxy][:home]}/scripts/api/install_tool_shed_repositories.py --url http://toolshed.g2.bx.psu.edu/ --api `echo #{node[:hiway][:galaxy][:home]}/api` --local http://localhost:8080/ --name cuffmerge --owner devteam --revision 424d49834830 --repository-deps --tool-deps --panel-section-name RNAseq
#{node[:hiway][:galaxy][:home]}/scripts/api/install_tool_shed_repositories.py --url http://toolshed.g2.bx.psu.edu/ --api `echo #{node[:hiway][:galaxy][:home]}/api` --local http://localhost:8080/ --name cuffcompare --owner devteam --revision 67695d7ff787 --repository-deps --tool-deps --panel-section-name RNAseq
#{node[:hiway][:galaxy][:home]}/scripts/api/install_tool_shed_repositories.py --url http://toolshed.g2.bx.psu.edu/ --api `echo #{node[:hiway][:galaxy][:home]}/api` --local http://localhost:8080/ --name cuffdiff --owner devteam --revision 604fa75232a2 --repository-deps --tool-deps --panel-section-name RNAseq
#{node[:hiway][:galaxy][:home]}/scripts/api/install_tool_shed_repositories.py --url http://toolshed.g2.bx.psu.edu/ --api `echo #{node[:hiway][:galaxy][:home]}/api` --local http://localhost:8080/ --name column_maker --owner devteam --revision 08a01b2ce4cd --repository-deps --tool-deps --panel-section-name RNAseq
