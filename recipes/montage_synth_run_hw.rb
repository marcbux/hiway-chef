# run the synthetic montage workflow on hiway
bash "run_montage_synthetic" do
  user node[:hiway][:user]
  group node[:hadoop][:group]
  code <<-EOH
  set -e && set -o pipefail
    hiway -w "#{node[:hiway][:data]}/#{node[:hiway][:montage_synthetic][:workflow]}" -l dax -s "#{node[:hiway][:data]}/montage_synthetic_summary.json"
    stage "#{node[:hiway][:data]}/montage_synthetic_summary.json" "#{node[:hiway][:data]}/"
  EOH
  not_if { ::File.exists?( "#{node[:hiway][:data]}/montage_synthetic_summary.json" ) }
end
