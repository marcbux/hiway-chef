name             'saasfee'
maintainer       "Marc Bux"
maintainer_email "bux@informatik.hu-berlin.de"
license          "Apache 2.0"
description      'Chef recipes for installing Hi-WAY, its dependencies, and several workflows.'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "1.0.0"

recipe           "kagent::install", "Installs the Karamel agent"
recipe           "hadoop::install", "Installs Hadoop 2 on the machines"
recipe           "kagent::default", "Configures the Karamel agent"
recipe           "hadoop::nn", "Installs a Hadoop Namenode"
recipe           "hadoop::rm", "Installs a YARN ResourceManager"
recipe           "hadoop::dn", "Installs a Hadoop Namenode"
recipe           "hadoop::nm", "Installs a YARN NodeManager"
recipe           "hadoop::jhs", "Installs a MapReduce History Server for YARN"
recipe           "saasfee::install", "Installs and sets up Hi-WAY"
recipe           "saasfee::hiway_client", "Configures Hadoop to support Hi-WAY on the Client"
recipe           "saasfee::hiway_worker", "Configures Hadoop to support Hi-WAY on the Workers"
recipe           "saasfee::galaxy_worker", "Installs, configures and updates Galaxy on the Workers"
recipe           "saasfee::cuneiform_client", "Installs Cuneiform with all its dependencies on the Client"
recipe           "saasfee::cuneiform_worker", "Installs Cuneiform with all its dependencies on the Workers"
recipe           "saasfee::helloworld_client", "Prepares the Hello World Cuneiform workflow on the Client"
recipe           "saasfee::helloworld_run_loc", "Runs the Hello World Cuneiform workflow locally on the Client via Cuneiform"
recipe           "saasfee::wordcount_client", "Prepares the Word Count Cuneiform workflow on the Client"
recipe           "saasfee::wordcount_run_loc", "Runs the Word Count Cuneiform workflow locally on the Client via Cuneiform"
recipe           "saasfee::montage_synth_client", "Prepares the synthetic Montage DAX workflow on the Client"
recipe           "saasfee::montage_synth_run_hw", "Runs the synthetic Montage DAX workflow on Hi-WAY from the Client"
recipe           "saasfee::galaxy101_client", "Prepares the Galaxy 101 Galaxy workflow on the Client"
recipe           "saasfee::galaxy101_worker", "Prepares the Galaxy 101 Galaxy workflow on the Workers"
recipe           "saasfee::galaxy101_run_hw", "Runs the Galaxy 101 Galaxy workflow on Hi-WAY from the Client"
recipe           "saasfee::variantcall_client", "Prepares the Variant Calling Cuneiform workflow on the Client"
recipe           "saasfee::variantcall_worker", "Prepares the Variant Calling Cuneiform workflow on the Workers"
recipe           "saasfee::variantcall_run_hw", "Runs the Variant Calling Cuneiform on Hi-WAY from the Client"
recipe           "saasfee::variantcall_scale_client", "Prepares a more performant version of the Variant Calling Cuneiform workflow on the Client"
recipe           "saasfee::variantcall_scale_worker", "Prepares a more performant version of the Variant Calling Cuneiform workflow on the Workers"
recipe           "saasfee::RNAseq_client", "Prepares the TRAPLINE RNAseq Galaxy Workflow on the Client"
recipe           "saasfee::RNAseq_worker", "Runs the TRAPLINE RNAseq Galaxy Workflow on Hi-WAY from the Client"
#recipe           "saasfee::montage_m17_4_client", "Prepares the Montage DAX Workflow on the Client"
#recipe           "saasfee::montage_m17_4_worker", "Prepares the Montage DAX Workflow on the Workers"

depends 'java'
depends 'git'
depends 'hadoop'
depends 'kagent'

%w{ ubuntu debian rhel centos }.each do |os|
  supports os
end

attribute "saasfee/user",
:display_name => "Name of the Hi-WAY user",
:description => "Name of the Hi-WAY user",
:type => 'string',
:default => "hiway"

attribute "saasfee/data",
:display_name => "Data directory",
:description => "Directory in which to store large data, e.g., input data of the workflow",
:type => 'string',
:default => "/home/hiway"

attribute "saasfee/workflows",
:display_name => "Workflows directory",
:description => "Directory in which to store the workflow files",
:type => 'string',
:default => "/home/hiway"

attribute "saasfee/software/dir",
:display_name => "Software directory",
:description => "Directory in which to store software (Saasfee and executables required by the workflows)",
:type => 'string',
:default => "/home/hiway/software"

attribute "saasfee/release",
:display_name => "Release or snaphsot",
:description => "Install Hi-WAY release as opposed to the latest snapshot version",
:type => 'string',
:default => "true"

attribute "saasfee/hiway/am/memory_mb",
:display_name => "Hi-WAY Application Master Memory in MB",
:description => "Amount of memory in MB to be requested to run the application master.",
:type => 'string',
:default => 512

attribute "saasfee/hiway/am/vcores",
:display_name => "Hi-WAY Application Master Number of Virtual Cores",
:description => "Hi-WAY Application Master Number of Virtual Cores",
:type => 'string',
:default => 1

attribute "saasfee/hiway/worker/memory_mb",
:display_name => "Hi-WAY Worker Memory in MB",
:description => "Hi-WAY Worker Memory in MB",
:type => 'string',
:default => 1024

attribute "saasfee/hiway/worker/vcores",
:display_name => "Hi-WAY Worker Number of Virtual Cores",
:description => "Hi-WAY Worker Number of Virtual Cores",
:type => 'string',
:default => 1

attribute "saasfee/hiway/scheduler",
:display_name => "Hi-WAY Scheduler",
:description => "valid values: c3po, cloning, conservative, greedyQueue, heft, outlooking, placementAware, staticRoundRobin",
:type => 'string',
:default => "placementAware"

attribute "saasfee/variantcall/reads/sample_id",
:display_name => "1000 Genomes Sample Id",
:description => "The Sample Id of sequence data from the 1000 Genomes project that is to be aligned",
:type => 'string',
:default => "HG02025"

attribute "saasfee/variantcall/reads/run_ids",
:display_name => "1000 Genomes Run Ids",
:description => "The Run Ids of sequence data from the 1000 Genomes project that is to be aligned",
:type => 'array',
:default => ["SRR359188", "SRR359195"]

attribute "saasfee/variantcall/reference/chromosomes",
:display_name => "Chromosomes",
:description => "The chromosomes of the reference against which sequence data is to be aligned",
:type => 'array',
:default => ["chr22", "chrY"]

attribute "saasfee/variantcall/reference/id",
:display_name => "Reference Id",
:description => "The Id of the reference which is to be downloaded",
:type => 'string',
:default => "hg38"

attribute "saasfee/variantcall/scale/url",
:display_name => "Variantcalling scale data URL",
:description => "URL from where to obtain input data for the variant call scale workflow",
:type => 'string',
:default => "https://s3.amazonaws.com/variantcall-scale/hg19.tar.gz"

attribute "saasfee/variantcall/scale/nsamples",
:display_name => "Number of Samples",
:description => "The maximum number of samples to be downloaded from the 1000 Genomes Project",
:type => 'string',
:default => "1"

attribute "saasfee/hiway/hdfs/basedir",
:display_name => "Hi-WAY HDFS directory",
:description => "The directory in HDFS relative to which Hi-WAY is to look for workflow input data",
:type => 'string',
:default => "/home/hiway/"

attribute "saasfee/variantcall/reads/url_base",
:display_name => "1k Genomes URL base",
:description => "Base directory for obtaining 1000 genomes reads files",
:type => 'string',
:default => "ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/phase3/data"

attribute "saasfee/montage/region",
:display_name => "Montage region",
:description => "Sky region for Montage workflow",
:type => 'string',
:default => "M17"

attribute "saasfee/montage/degree",
:display_name => "Montage degree",
:description => "Degree for Montage workflow",
:type => 'string',
:default => "4"
