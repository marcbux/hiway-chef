# run the word count workflow locally
bash "run_wordcount" do
  user node[:hiway][:user]
  group node[:hadoop][:group]
  code <<-EOH
  set -e && set -o pipefail
    cuneiform #{node[:hiway][:data]}/#{node[:hiway][:wordcount][:workflow]} -s "#{node[:hiway][:data]}/wordcount_summary.json"
    grep -oP '\"output\":\[\"\K[^\"]+' #{node[:hiway][:data]}/wordcount_summary.json
  EOH
  not_if "grep -q \"Hello #{node[:hiway][:user]}\" #{node[:hiway][:data]}/wordcount_summary.json"
end
