# run the variant calling workflow on hiway
bash "run_variant_calling" do
  user node[:hiway][:user]
  group node[:hadoop][:group]
  code <<-EOH
  set -e && set -o pipefail
    hiway -w "#{node[:hiway][:home]}/#{node[:hiway][:variantcall][:workflow]}" -s "#{node[:hiway][:home]}/variantcall_summary.json"
    stage "#{node[:hiway][:home]}/variantcall_summary.json" "#{node[:hiway][:home]}/"
  EOH
  not_if { ::File.exists?( "#{node[:hiway][:home]}/variantcall_summary.json" ) }
end
