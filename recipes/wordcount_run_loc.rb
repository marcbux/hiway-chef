# run the word count workflow locally
bash "run_wordcount" do
  user node[:saasfee][:user]
  group node[:hadoop][:group]
  code <<-EOH
  set -e && set -o pipefail
    cuneiform #{node[:saasfee][:workflows]}/#{node[:saasfee][:wordcount][:workflow]} -w #{node[:saasfee][:data]} -s #{node[:saasfee][:home]}/wordcount_summary.json
    head `grep -oP '\\"output\\":\\[\\"\\K[^\\"]+' #{node[:saasfee][:home]}/wordcount_summary.json`
  EOH
  not_if { ::File.exists?( "#{node[:saasfee][:home]}/wordcount_summary.json" ) }
end
