# run the variant calling workflow on hiway
bash "run_variant_calling" do
  user node[:hiway][:user]
  group node[:hadoop][:group]
  code <<-EOH
  set -e && set -o pipefail
    hiway -w "#{node[:hiway][:data]}/#{node[:hiway][:variantcall][:workflow]}" -s "#{node[:hiway][:data]}/variantcall_summary.json"
    stage "#{node[:hiway][:data]}/variantcall_summary.json" "#{node[:hiway][:data]}/"
  EOH
  not_if { ::File.exists?( "#{node[:hiway][:data]}/variantcall_summary.json" ) }
end
