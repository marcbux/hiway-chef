# run the hello world workflow locally
bash "run_helloworld" do
  user node[:hiway][:user]
  group node[:hadoop][:group]
  code <<-EOF
  set -e && set -o pipefail
    cuneiform #{node[:hiway][:cuneiform][:home]}/#{node[:hiway][:helloworld][:workflow]} -s #{node[:hiway][:cuneiform][:home]}/helloworld_summary.json
    grep -oP '\"output\":\[\"\K[^\"]+' #{node[:hiway][:cuneiform][:home]}/helloworld_summary.json
  EOF
  not_if "grep -q \"Hello #{node[:hiway][:user]}\" #{node[:hiway][:cuneiform][:home]}/helloworld_summary.json"
end
