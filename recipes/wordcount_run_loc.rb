# run the word count workflow locally
bash "run_wordcount" do
  user node[:hiway][:user]
  group node[:hadoop][:group]
  code <<-EOH
  set -e && set -o pipefail
    cuneiform #{node[:hiway][:workflows]}/#{node[:hiway][:wordcount][:workflow]} -w #{node[:hiway][:data]} -s #{node[:hiway][:home]}/wordcount_summary.json
    head `grep -oP '\\"output\\":\\[\\"\\K[^\\"]+' #{node[:hiway][:home]}/wordcount_summary.json`
  EOH
  not_if { ::File.exists?( "#{node[:hiway][:home]}/wordcount_summary.json" ) }
end
