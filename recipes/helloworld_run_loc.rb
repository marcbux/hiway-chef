# run the hello world workflow locally
bash "run_helloworld" do
  user node[:hiway][:user]
  group node[:hadoop][:group]
  code <<-EOH
  set -e && set -o pipefail
    cuneiform #{node[:hiway][:data]}/#{node[:hiway][:helloworld][:workflow]} -s #{node[:hiway][:data]}/helloworld_summary.json
    grep -oP '\"output\":\[\"\K[^\"]+' #{node[:hiway][:data]}/helloworld_summary.json
  EOH
  not_if "grep -q \"Hello #{node[:hiway][:user]}\" #{node[:hiway][:data]}/helloworld_summary.json"
end
