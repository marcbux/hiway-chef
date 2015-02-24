# run the variant calling workflow on hiway
bash "run_wordcount" do
  user node[:hiway][:user]
  group node[:hadoop][:group]
  code <<-EOH
  set -e && set -o pipefail
    hiway -w "#{node[:hiway][:home]}/#{node[:hiway][:variantcall][:hg38][:workflow]}" -s "#{node[:hiway][:home]}/variantcall_summary.json"
    stage "#{node[:hiway][:home]}/variantcall_summary.json"` "#{node[:hiway][:home]}/"
  EOH
  not_if { ::File.exists?( "#{node[:hiway][:home]}/variantcall_summary.json" ) }
end
