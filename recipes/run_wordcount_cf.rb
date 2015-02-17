# run the word count workflow
bash "run_wordcount" do
  user node[:hiway][:user]
  group node[:hadoop][:group]
  code <<-EOF
  set -e && set -o pipefail
    #{node[:hiway][:home]}/hiway -w #{node[:hiway][:home]}/#{node[:hiway][:wordcount][:workflow]} -s #{node[:hiway][:home]}/wordcount_summary.json
  EOF
end
