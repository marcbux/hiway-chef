# run the word count workflow locally
bash "run_wordcount" do
  user node[:hiway][:user]
  group node[:hadoop][:group]
  code <<-EOH
  set -e && set -o pipefail
    cuneiform #{node[:hiway][:data]}/#{node[:hiway][:wordcount][:workflow]} -w #{node[:hiway][:data]} -s #{node[:hiway][:data]}/wordcount_summary.json
    head `grep -oP '\\"output\\":\\[\\"\\K[^\\"]+' #{node[:hiway][:data]}/wordcount_summary.json`
  EOH
  not_if { ::File.exists?( "#{node[:hiway][:data]}/wordcount_summary.json" ) }
end
