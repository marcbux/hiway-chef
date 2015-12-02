# run the hello world workflow locally
bash "run_helloworld" do
  user node[:saasfee][:user]
  group node[:hadoop][:group]
  code <<-EOH
  set -e && set -o pipefail
    cuneiform #{node[:saasfee][:workflows]}/#{node[:saasfee][:helloworld][:workflow]} -s #{node[:saasfee][:home]}/helloworld_summary.json
    grep -oP '\"output\":\[\"\K[^\"]+' #{node[:saasfee][:home]}/helloworld_summary.json
  EOH
  not_if "grep -q \"Hello #{node[:saasfee][:user]}\" #{node[:saasfee][:home]}/helloworld_summary.json"
end
