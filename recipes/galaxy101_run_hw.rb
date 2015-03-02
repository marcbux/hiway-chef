# run the galaxy 101 workflow on hiway
bash "run_galaxy101" do
  user node[:hiway][:user]
  group node[:hadoop][:group]
  code <<-EOH
  set -e && set -o pipefail
    hiway -w "#{node[:hiway][:home]}/#{node[:hiway][:galaxy101][:workflow]}" -l galaxy -s "#{node[:hiway][:home]}/galaxy101_summary.json"
    stage "#{node[:hiway][:home]}/galaxy101_summary.json" "#{node[:hiway][:home]}/"
  EOH
  not_if { ::File.exists?( "#{node[:hiway][:home]}/galaxy101_summary.json" ) }
end
