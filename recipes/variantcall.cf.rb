template "#{node[:hiway][:home]}/#{node[:hiway][:variantcall][:setupworkflow]}" do
  user node[:hiway][:user]
  group node[:hiway][:group]
  source "#{node[:hiway][:variantcall][:setupworkflow]}.erb"
  mode "0774"
end

template "#{node[:hiway][:home]}/#{node[:hiway][:variantcall][:workflow]}" do
  user node[:hiway][:user]
  group node[:hiway][:group]
  source "#{node[:hiway][:variantcall][:workflow]}.erb"
  mode "0774"
end

prepared_variantcall = "/tmp/.prepared_variantcall"
bash "prepare_variantcall" do
  user node[:hiway][:user]
  group node[:hiway][:group]
  code <<-EOF
  set -e && set -o pipefail
  #{node[:hadoop][:home]}/bin/yarn jar #{node[:hiway][:home]}/hiway-core-#{node[:hiway][:version]}.jar -w #{node[:hiway][:home]}/#{node[:hiway][:variantcall][:setupworkflow]}}
  touch #{prepared_variantcall}
  EOF
#    not_if { ::File.exists?( "#{prepared_variantcall}" ) }
end

ran_variantcall = "/tmp/.ran_variantcall"
bash "run_variantcall" do
  user node[:hiway][:user]
  group node[:hiway][:group]
  code <<-EOF
  set -e && set -o pipefail
  #{node[:hadoop][:home]}/bin/yarn jar #{node[:hiway][:home]}/hiway-core-#{node[:hiway][:version]}.jar -w #{node[:hiway][:home]}/#{node[:hiway][:variantcall][:workflow]}}
  touch #{ran_variantcall}
  EOF
#    not_if { ::File.exists?( "#{ran_variantcall}" ) }
end
