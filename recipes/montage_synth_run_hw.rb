# run the synthetic montage workflow on hiway
bash "run_montage_synthetic" do
  user node[:saasfee][:user]
  group node[:hadoop][:group]
  code <<-EOH
  set -e && set -o pipefail
    hiway -w "#{node[:saasfee][:workflows]}/#{node[:saasfee][:montage_synthetic][:workflow]}" -l dax -s "#{node[:saasfee][:home]}/montage_synthetic_summary.json"
    stage "#{node[:saasfee][:home]}/montage_synthetic_summary.json" "#{node[:saasfee][:data]}/"
  EOH
  not_if { ::File.exists?( "#{node[:saasfee][:home]}/montage_synthetic_summary.json" ) }
end
