# run the galaxy 101 workflow on hiway
bash "run_galaxy101" do
  user node[:saasfee][:user]
  group node[:hadoop][:group]
  code <<-EOH
  set -e && set -o pipefail
    hiway -w "#{node[:saasfee][:workflows]}/#{node[:saasfee][:galaxy101][:workflow]}" -l galaxy -s "#{node[:saasfee][:home]}/galaxy101_summary.json"
    stage "#{node[:saasfee][:home]}/galaxy101_summary.json" "#{node[:saasfee][:data]}/"
  EOH
  not_if { ::File.exists?( "#{node[:saasfee][:home]}/galaxy101_summary.json" ) }
end
