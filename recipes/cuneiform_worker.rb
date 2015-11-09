# install R for Cuneiform
package "r-base" do
  options "--force-yes"
end

if node[:hiway][:release] == "false"
  # install Git
  include_recipe "git"
  
  # install Maven
  package "maven" do
    options "--force-yes"
  end
  
  # git clone Cuneiform
  git "/tmp/cuneiform" do
    repository node[:hiway][:cuneiform][:github_url]
    reference "master"
    user node[:hiway][:user]
    group node[:hadoop][:group]
    action :sync
  end

  # maven build Cuneiform
  bash 'build-and-copy-cuneiform' do
    user node[:hiway][:user]
    group node[:hadoop][:group]
    code <<-EOH
    set -e && set -o pipefail
      mvn -f /tmp/cuneiform/pom.xml package
      version=$(grep -Po '(?<=^\t<version>)[^<]*(?=</version>)' /tmp/cuneiform/pom.xml)
      cp -r /tmp/cuneiform/cuneiform-dist/target/cuneiform-dist-$version/cuneiform-$version #{node[:hiway][:cuneiform][:home]}
      rm #{node[:hiway][:hiway][:home]}/lib/cuneiform-core-#{node[:hiway][:cuneiform][:release][:version]}.jar
      cp #{node[:hiway][:cuneiform][:home]}/cuneiform-core-$version.jar #{node[:hiway][:hiway][:home]}/lib/cuneiform-core-$version.jar
    EOH
    not_if { ::File.exist?("#{node[:hiway][:cuneiform][:home]}") }
  end
end
