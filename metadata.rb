name             'hiway'
maintainer       "Marc Bux"
maintainer_email "bux@informatik.hu-berlin.de"
license          "Apache 2.0"
description      'Chef recipes for installing Hi-WAY, its dependencies, and several workflows.'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "1.0.0"

#recipe           "kagent::install", "Installs the Karamel agent"
recipe           "hadoop::install", "Installs Hadoop 2 on the machines"
#recipe           "kagent::default", "Configures the Karamel agent"
recipe           "hadoop::nn", "Installs a Hadoop Namenode"
recipe           "hadoop::rm", "Installs a YARN ResourceManager"
recipe           "hadoop::dn", "Installs a Hadoop Namenode"
recipe           "hadoop::nm", "Installs a YARN NodeManager"
recipe           "hadoop::jhs", "Installs a MapReduce History Server for YARN"
recipe           "hiway::install", "Installs and sets up Hi-WAY"
recipe           "hiway::rm", "Configures Hadoop to support Hi-WAY on the RM"
recipe           "hiway::nm", "Configures Hadoop to support Hi-WAY on the NMs"
recipe           "hiway::galaxy", "Installs, configures and updates Galaxy"
recipe           "hiway::cuneiform", "Installs Cuneiform with all its dependencies"
recipe           "hiway::helloworld_client", "Prepares the Hello World Cuneiform workflow on the Client"
recipe           "hiway::helloworld_run_loc", "Runs the Hello World Cuneiform workflow locally on the Client via Cuneiform"
recipe           "hiway::wordcount_client", "Prepares the Word Count Cuneiform workflow on the Client"
recipe           "hiway::wordcount_run_loc", "Runs the Word Count Cuneiform workflow locally on the Client via Cuneiform"
recipe           "hiway::variantcall_hg38_client", "Prepares the HG38 Variant Calling Cuneiform workflow on the Client"
recipe           "hiway::variantcall_hg38_worker", "Prepares the HG38 Variant Calling Cuneiform workflow on the Workers"
recipe           "hiway::variantcall_hg38_run_hw", "Runs the HG38 Variant Calling Cuneiform on Hi-WAY from the Client"
recipe           "hiway::montage_synth_client", "Prepares the synthetic Montage DAX workflow on the Client"
recipe           "hiway::montage_synth_run_hw", "Runs the synthetic Montage DAX workflow on Hi-WAY from the Client"
recipe           "hiway::galaxy101_client", "Prepares the Galaxy 101 Galaxy workflow on the Client"
recipe           "hiway::galaxy101_worker", "Prepares the Galaxy 101 Galaxy workflow on the Workers"
recipe           "hiway::galaxy101_run_hw", "Runs the Galaxy 101 Galaxy workflow on Hi-WAY from the Client"
#recipe           "hiway::variantcall_hg19_client", "Prepares the HG19 Variant Calling Cuneiform workflow"
#recipe           "hiway::montage_m17_4_client", "Prepares the Montage DAX Workflow"
#recipe           "hiway::RNASeq_client", "Prepares the TRAPLINE RNASeq Galaxy Workflow"

depends 'hadoop'
depends 'locale'

%w{ ubuntu debian rhel centos }.each do |os|
  supports os
end

attribute "hiway/user",
:display_name => "Name of the Hi-WAY user",
:description => "Name of the Hi-WAY user",
:type => 'string',
:default => "hiway"

attribute "hiway/hiway/am/memory",
:display_name => "Hi-WAY Application Master Memory in MB",
:description => "Amount of memory in MB to be requested to run the application master.",
:type => 'integer',
:default => 512

attribute "hiway/hiway/am/vcores",
:display_name => "Hi-WAY Application Master Number of Virtual Cores",
:description => "Hi-WAY Application Master Number of Virtual Cores",
:type => 'integer',
:default => 1

attribute "hiway/hiway/worker/memory",
:display_name => "Hi-WAY Worker Memory in MB",
:description => "Hi-WAY Worker Memory in MB",
:type => 'integer',
:default => 1024

attribute "hiway/hiway/worker/vcores",
:display_name => "Hi-WAY Worker Number of Virtual Cores",
:description => "Hi-WAY Worker Number of Virtual Cores",
:type => 'integer',
:default => 1

attribute "hiway/hiway/scheduler",
:display_name => "Hi-WAY Scheduler",
:description => "valid values: c3po, cloning, conservative, greedyQueue, heft, outlooking, placementAware, staticRoundRobin",
:type => 'string',
:default => "placementAware"
