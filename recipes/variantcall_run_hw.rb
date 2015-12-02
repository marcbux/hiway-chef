# run the variant calling workflow on hiway
bash "run_variant_calling" do
  user node[:saasfee][:user]
  group node[:hadoop][:group]
  code <<-EOH
  set -e && set -o pipefail
    hiway -w "#{node[:saasfee][:workflows]}/#{node[:saasfee][:variantcall][:workflow]}" -s "#{node[:saasfee][:home]}/variantcall_summary.json"
    stage "#{node[:saasfee][:home]}/variantcall_summary.json" "#{node[:saasfee][:data]}/"
  EOH
  not_if { ::File.exists?( "#{node[:saasfee][:home]}/variantcall_summary.json" ) }
end
