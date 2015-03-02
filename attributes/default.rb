include_attribute "hadoop"

#default[:hiway][:resolution]                        = "1024x768x32"

default[:hiway][:user]                              = "hiway"
default[:hiway][:home]                              = "/home/#{node[:hiway][:user]}"
default[:hiway][:software][:dir]                    = node[:hadoop][:dir]

default[:hiway][:hiway][:hdfs][:basedir]            = "/"
default[:hiway][:hiway][:version]                   = "1.0.0-SNAPSHOT"
default[:hiway][:hiway][:home]                      = "#{node[:hiway][:software][:dir]}/hiway-#{node[:hiway][:hiway][:version]}"
default[:hiway][:hiway][:github_url]                = "https://github.com/marcbux/Hi-WAY.git"
default[:hiway][:hiway][:am][:memory]               = 512
default[:hiway][:hiway][:am][:vcores]               = 1
default[:hiway][:hiway][:worker][:memory]           = 1024
default[:hiway][:hiway][:worker][:vcores]           = 1
default[:hiway][:hiway][:scheduler]                 = "placementAware"

default[:hiway][:cuneiform][:version]               = "2.0.0-SNAPSHOT"
default[:hiway][:cuneiform][:home]                  = "#{node[:hiway][:software][:dir]}/cuneiform-#{node[:hiway][:cuneiform][:version]}"
default[:hiway][:cuneiform][:github_url]            = "https://github.com/joergen7/cuneiform.git"
default[:hiway][:cuneiform][:r_packages]            = "node[:hiway][:software][:dir]/r_packages"
default[:hiway][:cuneiform][:cache]                 = "/tmp/cf-cache"

default[:hiway][:galaxy][:repository]               = "https://bitbucket.org/galaxy/galaxy-dist/"
default[:hiway][:galaxy][:home]                     = "#{node[:hiway][:software][:dir]}/galaxy" 
default[:hiway][:galaxy][:master_api_key]           = "reverse"
default[:hiway][:galaxy][:admin_users]              = "hiway@hiway.com"

default[:hiway][:helloworld][:workflow]             = "helloworld.cf"

default[:hiway][:wordcount][:workflow]              = "wordcount.cf"
default[:hiway][:wordcount][:input][:url]           = "http://stateoftheunion.onetwothree.net/texts/stateoftheunion1790-2014.txt.zip"
default[:hiway][:wordcount][:input][:zip]           = "stateoftheunion1790-2014.zip"
default[:hiway][:wordcount][:input][:txt]           = "stateoftheunion1790-2014.txt"

default[:hiway][:variantcall][:hg19][:setupworkflow]       = "variantcall.setup.cf"
default[:hiway][:variantcall][:hg19][:workflow]            = "variantcall.cf"
default[:hiway][:variantcall][:hg19][:splitsize_reference] = 12000
default[:hiway][:variantcall][:hg19][:paired_read_files]   = 1
default[:hiway][:variantcall][:hg19][:iterations]          = 1
default[:hiway][:variantcall][:hg19][:threads]             = 1
default[:hiway][:variantcall][:hg19][:memory]              = 4096000000

default[:hiway][:variantcall][:hg38][:workflow]              = "variantcall.hg38.cf"
default[:hiway][:variantcall][:hg38][:reads][:directory]     = "1000genomes"
default[:hiway][:variantcall][:hg38][:reads][:gz1]           = "SRR062634_1.filt.fastq.gz"
default[:hiway][:variantcall][:hg38][:reads][:gz2]           = "SRR062634_2.filt.fastq.gz"
default[:hiway][:variantcall][:hg38][:reads][:file1]         = "SRR062634_1.filt.part.fastq"
default[:hiway][:variantcall][:hg38][:reads][:file2]         = "SRR062634_2.filt.part.fastq"
default[:hiway][:variantcall][:hg38][:reads][:url]           = "ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/data/HG00096/sequence_read"
default[:hiway][:variantcall][:hg38][:reads][:lines]         = 400000
default[:hiway][:variantcall][:hg38][:reference][:directory] = "hg38"
default[:hiway][:variantcall][:hg38][:reference][:gz1]       = "chrY.fa.gz"
default[:hiway][:variantcall][:hg38][:reference][:gz2]       = "chr22.fa.gz"
default[:hiway][:variantcall][:hg38][:reference][:file1]     = "chrY.fa"
default[:hiway][:variantcall][:hg38][:reference][:file2]     = "chr22.fa"
default[:hiway][:variantcall][:hg38][:reference][:url]       = "ftp://hgdownload.soe.ucsc.edu/apache/htdocs/goldenPath/hg38/chromosomes"
default[:hiway][:variantcall][:hg38][:annovardb][:directory] = "annodb"
default[:hiway][:variantcall][:hg38][:annovardb][:file]      = "hg38db.tar"

default[:hiway][:variantcall][:bowtie2][:version]   = "2.2.4"
default[:hiway][:variantcall][:bowtie2][:zip]       = "bowtie2-#{node[:hiway][:variantcall][:bowtie2][:version]}-linux-x86_64.zip"
default[:hiway][:variantcall][:bowtie2][:home]      = "#{node[:hiway][:software][:dir]}/bowtie2-#{node[:hiway][:variantcall][:bowtie2][:version]}"
default[:hiway][:variantcall][:bowtie2][:url]       = "http://ufpr.dl.sourceforge.net/project/bowtie-bio/bowtie2/#{node[:hiway][:variantcall][:bowtie2][:version]}/#{node[:hiway][:variantcall][:bowtie2][:zip]}"
default[:hiway][:variantcall][:bwa][:version]       = "0.7.12"
default[:hiway][:variantcall][:bwa][:tarbz2]        = "bwa-#{node[:hiway][:variantcall][:bwa][:version]}.tar.bz2"
default[:hiway][:variantcall][:bwa][:home]          = "#{node[:hiway][:software][:dir]}/bwa-#{node[:hiway][:variantcall][:bwa][:version]}"
default[:hiway][:variantcall][:bwa][:url]           = "http://downloads.sourceforge.net/project/bio-bwa/#{node[:hiway][:variantcall][:bwa][:tarbz2]}"
default[:hiway][:variantcall][:samtools][:version]  = "1.2"
default[:hiway][:variantcall][:samtools][:tarbz2]   = "samtools-#{node[:hiway][:variantcall][:samtools][:version]}.tar.bz2"
default[:hiway][:variantcall][:samtools][:home]     = "#{node[:hiway][:software][:dir]}/samtools-#{node[:hiway][:variantcall][:samtools][:version]}"
default[:hiway][:variantcall][:samtools][:url]      = "http://garr.dl.sourceforge.net/project/samtools/samtools/#{node[:hiway][:variantcall][:samtools][:version]}/#{node[:hiway][:variantcall][:samtools][:tarbz2]}"
default[:hiway][:variantcall][:varscan][:version]   = "2.3.7"
default[:hiway][:variantcall][:varscan][:jar]       = "VarScan.v#{node[:hiway][:variantcall][:varscan][:version]}.jar"
default[:hiway][:variantcall][:varscan][:home]      = "#{node[:hiway][:software][:dir]}/varscan-#{node[:hiway][:variantcall][:samtools][:version]}"
default[:hiway][:variantcall][:varscan][:url]       = "http://downloads.sourceforge.net/project/varscan/#{node[:hiway][:variantcall][:varscan][:jar]}"
default[:hiway][:variantcall][:annovar][:targz]     = "annovar.latest.tar.gz"
default[:hiway][:variantcall][:annovar][:home]      = "#{node[:hiway][:software][:dir]}/annovar"
default[:hiway][:variantcall][:annovar][:url]       = "http://www.openbioinformatics.org/annovar/download/g4EUwyphi9/#{node[:hiway][:variantcall][:annovar][:targz]}"

default[:hiway][:montage_synthetic][:workflow]       = "Montage_25.xml"
default[:hiway][:montage_synthetic][:url]            = "https://confluence.pegasus.isi.edu/download/attachments/2490624/#{node[:hiway][:montage_synthetic][:workflow]}"

default[:hiway][:montage_m17_4][:workflow]           = "montage_m17_4.dax"
default[:hiway][:montage_m17_4][:montage][:version]  = "3.3"
default[:hiway][:montage_m17_4][:montage][:targz]    = "Montage_v#{node[:hiway][:montage_m17_4][:montage][:version]}.tar.gz"
default[:hiway][:montage_m17_4][:montage][:home]     = "#{node[:hiway][:software][:dir]}/Montage_v#{node[:hiway][:montage_m17_4][:montage][:version]}"
default[:hiway][:montage_m17_4][:montage][:url]      = "http://montage.ipac.caltech.edu/download/#{node[:hiway][:montage_m17_4][:montage][:targz]}"

default[:hiway][:galaxy101][:workflow]               = "galaxy101.ga"
default[:hiway][:galaxy101][:exons]                  = "Exons.bed"
default[:hiway][:galaxy101][:snps]                   = "SNPs.bed"

default[:hiway][:RNASeq][:workflow]                  = "RNASeq.ga"
