# run the synthetic montage workflow on hiway
bash "run_montage_synthetic" do
  user node[:hiway][:user]
  group node[:hadoop][:group]
  code <<-EOH
  set -e && set -o pipefail
    hiway -w "#{node[:hiway][:home]}/#{node[:hiway][:montage_synthetic][:workflow]}" -l dax -s "#{node[:hiway][:home]}/montage_synthetic_summary.json"
    #{node[:hadoop][:home]}/bin/hdfs dfs -get `grep -oP '\"output\":\[\"\K[^\"]+' "#{node[:hiway][:home]}/montage_synthetic_summary.json"`
  EOH
  not_if { ::File.exists?( "#{node[:hiway][:home]}/montage_synthetic_summary.json" ) }
end
