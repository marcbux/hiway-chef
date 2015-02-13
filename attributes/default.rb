include_attribute "hadoop"

default[:hadoop][:version]                          = "2.6.0"
default[:hadoop][:download_url]                     = "http://apache.mirror.digionline.de/hadoop/common/hadoop-#{node[:hadoop][:version]}/hadoop-#{node[:hadoop][:version]}.tar.gz"
default[:hadoop][:hadoop_src_url]                   = "http://apache.mirror.digionline.de/hadoop/common/hadoop-#{node[:hadoop][:version]}/hadoop-#{node[:hadoop][:version]}-src.tar.gz"
default[:hadoop][:native_libraries]                 = "false"

default[:hadoop][:yarn][:nm][:memory_mbs]           = 4096
default[:hadoop][:yarn][:vpmem_ratio]               = 4.1
default[:hadoop][:yarn][:vcores]                    = 2
default[:hadoop][:yarn][:app_classpath]             = "$HADOOP_CONF_DIR, $HADOOP_COMMON_HOME/share/hadoop/common/*, $HADOOP_COMMON_HOME/share/hadoop/common/lib/*, $HADOOP_HDFS_HOME/share/hadoop/hdfs/*, $HADOOP_HDFS_HOME/share/hadoop/hdfs/lib/*, $HADOOP_YARN_HOME/share/hadoop/yarn/*, $HADOOP_YARN_HOME/share/hadoop/yarn/lib/*, $HIWAY_HOME/*, $HIWAY_HOME/lib/*"

default[:hiway][:user]                              = "hiway"
default[:hiway][:software][:dir]                    = node[:hadoop][:dir]
default[:hiway][:hdfs][:basedir]                    = "/user/#{node[:hiway][:user]}"

default[:hiway][:version]                           = "1.0.0-SNAPSHOT"
default[:hiway][:home]                              = "#{node[:hiway][:software][:dir]}/hiway-#{node[:hiway][:version]}"
default[:hiway][:github_url]                        = "https://github.com/marcbux/Hi-WAY.git"

default[:hiway][:cuneiform][:version]               = "2.0.0-SNAPSHOT"
default[:hiway][:cuneiform][:home]                  = "#{node[:hiway][:software][:dir]}/cuneiform-#{node[:hiway][:cuneiform][:version]}"
default[:hiway][:cuneiform][:github_url]            = "https://github.com/joergen7/cuneiform.git"
default[:hiway][:cuneiform][:r_packages]            = "node[:hiway][:software][:dir]/r_packages"
default[:hiway][:cuneiform][:cache]                 = "/tmp"

default[:hiway][:galaxy][:repository]               = "https://bitbucket.org/galaxy/galaxy-dist/"
default[:hiway][:galaxy][:home]                     = "#{node[:hiway][:software][:dir]}/galaxy" 
default[:hiway][:galaxy][:master_api_key]           = "reverse"
default[:hiway][:galaxy][:admin_users]              = "hiway@hiway.com"

default[:hiway][:helloworld][:workflow]             = "helloworld.cf"

default[:hiway][:wordcount][:workflow]              = "wordcount.cf"
default[:hiway][:wordcount][:input][:url]           = "http://stateoftheunion.onetwothree.net/texts/stateoftheunion1790-2014.txt.zip"
default[:hiway][:wordcount][:input][:zip]           = "stateoftheunion1790-2014.zip"
default[:hiway][:wordcount][:input][:txt]           = "stateoftheunion1790-2014.txt"

default[:hiway][:variantcall][:setupworkflow]       = "variantcall.setup.cf"
default[:hiway][:variantcall][:workflow]            = "variantcall.cf"
default[:hiway][:variantcall][:bowtie2][:version]   = "2.2.2"
default[:hiway][:variantcall][:bowtie2][:zip]       = "bowtie2-#{node[:hiway][:variantcall][:bowtie2][:version]}-linux-x86_64.zip"
default[:hiway][:variantcall][:bowtie2][:home]      = "#{node[:hiway][:software][:dir]}/bowtie2-#{node[:hiway][:variantcall][:bowtie2][:version]}"
default[:hiway][:variantcall][:bowtie2][:url]       = "http://downloads.sourceforge.net/project/bowtie-bio/bowtie2/#{node[:hiway][:variantcall][:bowtie2][:version]}/#{node[:hiway][:variantcall][:bowtie2][:zip]}"
default[:hiway][:variantcall][:samtools][:version]  = "0.1.19"
default[:hiway][:variantcall][:samtools][:tarbz2]   = "samtools-#{node[:hiway][:variantcall][:samtools][:version]}.tar.bz2"
default[:hiway][:variantcall][:samtools][:home]     = "#{node[:hiway][:software][:dir]}/samtools-#{node[:hiway][:variantcall][:samtools][:version]}"
default[:hiway][:variantcall][:samtools][:url]      = "http://garr.dl.sourceforge.net/project/samtools/samtools/#{node[:hiway][:variantcall][:samtools][:version]}/#{node[:hiway][:variantcall][:samtools][:tarbz2]}"
default[:hiway][:variantcall][:varscan][:version]   = "2.3.6"
default[:hiway][:variantcall][:varscan][:jar]       = "VarScan.v#{node[:hiway][:variantcall][:varscan][:version]}.jar"
default[:hiway][:variantcall][:varscan][:url]       = "http://downloads.sourceforge.net/project/varscan/#{node[:hiway][:variantcall][:varscan][:jar]}"
default[:hiway][:variantcall][:annovar][:targz]     = "annovar.latest.tar.gz"
default[:hiway][:variantcall][:annovar][:home]      = "#{node[:hiway][:software][:dir]}/annovar"
default[:hiway][:variantcall][:annovar][:url]       = "http://www.openbioinformatics.org/annovar/download/g4EUwyphi9/#{node[:hiway][:variantcall][:annovar][:targz]}"
default[:hiway][:variantcall][:splitsize_reference] = 12000
default[:hiway][:variantcall][:paired_read_files]   = 1
default[:hiway][:variantcall][:iterations]          = 1
default[:hiway][:variantcall][:threads]             = 1
default[:hiway][:variantcall][:memory]              = 4096000000

default[:hiway][:montage_synthetic][:workflow]       = "Montage_25.xml"
default[:hiway][:montage_synthetic][:url]            = "https://confluence.pegasus.isi.edu/download/attachments/2490624/#{node[:hiway][:montage_synthetic][:workflow]}"

default[:hiway][:montage_m17_4][:workflow]           = "montage_m17_4.dax"
default[:hiway][:montage_m17_4][:montage][:version]  = "3.3"
default[:hiway][:montage_m17_4][:montage][:targz]    = "Montage_v#{node[:hiway][:montage_m17_4][:montage][:version]}.tar.gz"
default[:hiway][:montage_m17_4][:montage][:home]     = "#{node[:hiway][:software][:dir]}/Montage_v#{node[:hiway][:montage_m17_4][:montage][:version]}"
default[:hiway][:montage_m17_4][:montage][:url]      = "http://montage.ipac.caltech.edu/download/#{node[:hiway][:montage_m17_4][:montage][:targz]}"

default[:hiway][:galaxy101][:workflow]               = "galaxy101.ga"

default[:hiway][:RNASeq][:workflow]                  = "RNASeq.ga"
