# prepare the variant call workflow file
template "#{node[:saasfee][:workflows]}/#{node[:saasfee][:variantcall][:scale][:workflow]}" do
  user node[:saasfee][:user]
  group node[:hadoop][:group]
  source "#{node[:saasfee][:variantcall][:scale][:workflow]}.erb"
  mode "755"
  variables({
     :gz => node[:saasfee][:variantcall][:scale][:gz],
  })
end
