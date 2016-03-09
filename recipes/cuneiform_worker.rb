# (1) install R for Cuneiform
package "r-base" do
  options "--force-yes"
end

# (2) install Erlang for Cuneiform
erlang_vsn = "18.2.1"
erlang_link = "http://www.erlang.org/download/otp_src_#{erlang_vsn}.tar.gz"
erlang_tar  = "#{Chef::Config[:file_cache_path]}/#{File.basename( erlang_link )}"
erlang_dir  = "#{node[:saasfee][:software][:dir]}/otp_src_#{erlang_vsn}"

package "fop"
package "libgtk-3-dev"
package "libncurses5-dev"
package "libqt5opengl5-dev"
package "libssl-dev"
package "libwxbase3.0-dev"
package "libwxgtk3.0-dev"
package "libxml2-utils"
package "unixodbc-dev"
package "xsltproc"

remote_file erlang_tar do
    action :create_if_missing
    source erlang_link
end

bash "extract_erlang" do
    code "tar xf #{erlang_tar} -C #{node[:saasfee][:software][:dir]}"
    not_if "#{Dir.exists?( erlang_dir )}"
end

bash "configure_erlang" do
    code "./configure"
    cwd erlang_dir
    not_if "#{File.exists?( "#{erlang_dir}/Makefile" )}"
end

bash "compile_erlang" do
    code "make"
    cwd erlang_dir
    not_if "#{File.exists?( "#{erlang_dir}/bin/erl" )}"
end

bash "install_erlang" do
    code "make install"
    cwd erlang_dir
    not_if "#{File.exists?( "/usr/local/bin/erl" )}"
end

# (3) install Rebar for Cuneiform
rebar_githuburl = "https://github.com/rebar/rebar.git"
rebar_vsn = "2.6.1"
rebar_dir = "#{node[:saasfee][:software][:dir]}/rebar"

# directories
directory node[:saasfee][:software][:dir]

# clone rebar github repository
git "git_clone_rebar" do
  action :checkout
  repository rebar_githuburl
  destination rebar_dir
  revision rebar_vsn
end

# build rebar
bash "build_rebar" do
  code "./bootstrap"
  cwd rebar_dir
  not_if "#{File.exists?( "#{rebar_dir}/rebar" )}"
end

# create link
link "/usr/bin//rebar" do
    to "#{rebar_dir}/rebar"
end

# (4) install Getopt for Cuneiform
getopt_githuburl = "https://github.com/jcomellas/getopt.git"
getopt_vsn = "v0.8.2"
getopt_dir = "#{node[:saasfee][:software][:dir]}/getopt-0.8.2"

git "git_clone_getopt" do
  action :checkout
  repository getopt_githuburl
  destination getopt_dir
  revision getopt_vsn
end

bash "compile_getopt" do
  code "rebar co"
  cwd getopt_dir
  not_if "#{File.exists?( "#{getopt_dir}/ebin/getopt.beam" )}"
end

link "/usr/local/lib/erlang/lib/getopt-0.8.2" do
  to "#{getopt_dir}/ebin"
end

# (5) install Cuneiform's Erlang Foreign Function Interface
effi_githuburl = "https://github.com/joergen7/effi.git"
effi_vsn = "master"
effi_dir = "#{node[:saasfee][:software][:dir]}/effi-0.1.0"

git "git_clone_effi" do
  action :sync
  repository effi_githuburl
  destination effi_dir
  revision effi_vsn
end

bash "compile_effi" do
  code "rebar co"
  cwd effi_dir
  # not_if "#{File.exists?( "#{effi_dir}/ebin/effi.beam" )}"
end

link "/usr/local/lib/erlang/lib/effi-0.1.0" do
  to "#{effi_dir}/ebin"
end

link "/usr/bin//effi" do
  to "#{effi_dir}/priv/effi"
end
