# run the word count workflow locally
bash "run_wordcount" do
  user node[:hiway][:user]
  group node[:hadoop][:group]
  code <<-EOH
  set -e && set -o pipefail
    cuneiform #{node[:hiway][:home]}/#{node[:hiway][:wordcount][:workflow]} -s "#{node[:hiway][:home]}/wordcount_summary.json"
  EOH
end
