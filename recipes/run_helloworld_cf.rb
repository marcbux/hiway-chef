bash "run_helloworld" do
  user node[:hiway][:user]
  group node[:hadoop][:group]
  code <<-EOF
  set -e && set -o pipefail
    hiway -w #{node[:hiway][:home]}/#{node[:hiway][:helloworld][:workflow]} -s #{node[:hiway][:home]}/helloworld_summary.json
    
  EOF
  #    `#{node[:hiway][:home]}/helloworld_summary.json`
#  not_if { ::File.exists?("#{node[:hiway][:home]}/wordcount_summary.json") }
end

#{node[:hadoop][:home]}/bin/yarn jar #{node[:hiway][:home]}/hiway-core-#{node[:hiway][:version]}.jar -w #{node[:hiway][:home]}/#{node[:hiway][:helloworld][:workflow]} -s #{node[:hiway][:home]}/helloworld_summary.json
