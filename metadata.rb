name             'hiway'
maintainer       "Marc Bux"
maintainer_email "bux@informatik.hu-berlin.de"
license          "Apache 2.0"
description      'Installs/Configures Hiway, its dependencies and several test workflows'
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
recipe           "hiway::hadoop", "Configures Hadoop to support Hi-WAY"
recipe           "hiway::cuneiform", "Installs Cuneiform with all its dependencies"
recipe           "hiway::cuneiform_helloworld_cf_prepare", "Prepares the Hello World Cuneiform workflow"
#recipe           "hiway::cuneiform_helloworld_cf_run", "Runs the Hello World Cuneiform workflow locally via Cuneiform"
recipe           "hiway::cuneiform_variantcall_hg38_cf_prepare", "Prepares the HG38 Variant Calling Cuneiform workflow"
recipe           "hiway::galaxy", "Installs, configures and updates Galaxy"
recipe           "hiway::hiway_wordcount_cf_prepare", "Prepares the Word Count Cuneiform workflow"
#recipe           "hiway::hiway_wordcount_cf_run", "Runs the Word Count Cuneiform workflow on Hadoop"
recipe           "hiway::hiway_montage_synthetic_dax_prepare", "Prepares the synthetic Montage DAX workflow"
#recipe           "hiway::hiway_montage_synthetic_dax_run", "Runs the synthetic Montage DAX workflow on Hadoop"
recipe           "hiway::hiway_galaxy101_ga_prepare", "Prepares the Galaxy 101 Galaxy workflow"
#recipe           "hiway::hiway_galaxy101_ga_run", "Runs the Galaxy 101 Galaxy workflow on Hadoop"
#recipe           "hiway::hiway_variantcall_cf_prepare", "Prepares the HG19 Variant Calling Cuneiform workflow"
#recipe           "hiway::hiway_montage_m17_4_dax_prepare", "Prepares the Montage DAX Workflow"
#recipe           "hiway::hiway_RNASeq_ga_prepare", "Prepares the TRAPLINE RNASeq Galaxy Workflow"

depends 'hadoop'

%w{ ubuntu debian rhel centos }.each do |os|
  supports os
end

attribute "hadoop/version",
:display_name => "Hadoop version",
:description => "Version of hadoop",
:type => 'string',
:default => "2.6.0"
