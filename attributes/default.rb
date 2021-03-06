include_attribute "hadoop"

#default[:saasfee][:resolution]                       = "1024x768x32"
default[:saasfee][:release]                           = "false"
default[:saasfee][:user]                              = "hiway"
default[:saasfee][:home]                              = "/home/#{node[:saasfee][:user]}"
default[:saasfee][:workflows]                         = "#{node[:saasfee][:home]}"
default[:saasfee][:data]                              = "#{node[:saasfee][:home]}/data"
default[:saasfee][:software][:dir]                    = "#{node[:saasfee][:home]}/software"

default[:saasfee][:hiway][:release][:version]         = "1.0.1-beta"
default[:saasfee][:hiway][:release][:targz]           = "hiway-dist-#{node[:saasfee][:hiway][:release][:version]}.tar.gz"
default[:saasfee][:hiway][:release][:url]             = "https://github.com/marcbux/Hi-WAY/releases/download/#{node[:saasfee][:hiway][:release][:version]}/#{node[:saasfee][:hiway][:release][:targz]}"
default[:saasfee][:hiway][:github_url]                = "https://github.com/marcbux/Hi-WAY.git"
default[:saasfee][:hiway][:home]                      = "#{node[:saasfee][:software][:dir]}/hiway"
default[:saasfee][:hiway][:hdfs][:basedir]            = "/user/#{node[:saasfee][:user]}/"
default[:saasfee][:hiway][:am][:memory_mb]            = 1024
default[:saasfee][:hiway][:am][:vcores]               = 1
default[:saasfee][:hiway][:worker][:memory_mb]        = 1024
default[:saasfee][:hiway][:worker][:vcores]           = 1
default[:saasfee][:hiway][:scheduler]                 = "dataAware"

default[:saasfee][:cuneiform][:release][:version]     = "2.0.4-RELEASE"
default[:saasfee][:cuneiform][:release][:jar]         = "cuneiform-dist-#{node[:saasfee][:cuneiform][:release][:version]}.jar"
default[:saasfee][:cuneiform][:release][:url]         = "https://github.com/joergen7/cuneiform/releases/download/#{node[:saasfee][:cuneiform][:release][:version]}/#{node[:saasfee][:cuneiform][:release][:jar]}"
default[:saasfee][:cuneiform][:home]                  = "#{node[:saasfee][:software][:dir]}/cuneiform"
default[:saasfee][:cuneiform][:r_packages]            = "#{node[:saasfee][:software][:dir]}/r_packages"
default[:saasfee][:cuneiform][:cache]                 = "/tmp/cf-cache"

default[:saasfee][:galaxy][:repository]               = "https://bitbucket.org/galaxy/galaxy-dist/"
default[:saasfee][:galaxy][:home]                     = "#{node[:saasfee][:software][:dir]}/galaxy"
default[:saasfee][:galaxy][:master_api_key]           = "reverse"
# name of at least four lower-case characters, numbers, or the "-" character
default[:saasfee][:galaxy][:user][:name]              = "#{node[:saasfee][:user]}"
# password of at least six characters
default[:saasfee][:galaxy][:user][:password]          = "#{node[:saasfee][:galaxy][:master_api_key]}"
default[:saasfee][:galaxy][:user][:email]             = "hiway@hiway.com"

default[:saasfee][:helloworld][:workflow]             = "helloworld.cf"
default[:saasfee][:kmeans][:workflow]                 = "kmeans.cf"

default[:saasfee][:wordcount][:workflow]              = "wordcount.cf"
default[:saasfee][:wordcount][:input][:url]           = "http://stateoftheunion.onetwothree.net/texts/stateoftheunion1790-2014.txt.zip"
default[:saasfee][:wordcount][:input][:zip]           = "stateoftheunion1790-2014.zip"
default[:saasfee][:wordcount][:input][:txt]           = "stateoftheunion1790-2014.txt"

default[:saasfee][:variantcall][:workflow]              = "variantcall.cf"
default[:saasfee][:variantcall][:threads]               = "#{node[:saasfee][:hiway][:worker][:vcores]}"
default[:saasfee][:variantcall][:memory_mb]             = "#{node[:saasfee][:hiway][:worker][:memory_mb]}"

default[:saasfee][:variantcall][:reads][:sample_id]     = "HG02025"
default[:saasfee][:variantcall][:reads][:run_ids]       = ["SRR359188", "SRR359195"]
default[:saasfee][:variantcall][:reads][:url_base]      = "ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/phase3/data"

default[:saasfee][:variantcall][:reference][:id]          = "hg38" 
default[:saasfee][:variantcall][:reference][:chromosomes] = ["chr22", "chrY"]
default[:saasfee][:variantcall][:reference][:url_base]    = "ftp://hgdownload.soe.ucsc.edu/goldenPath/#{node[:saasfee][:variantcall][:reference][:id]}/chromosomes"

default[:saasfee][:variantcall][:annovardb][:directory] = "annodb"
default[:saasfee][:variantcall][:annovardb][:file]      = "hg38db.tar"
default[:saasfee][:variantcall][:bowtie2][:version]   = "2.2.5"
default[:saasfee][:variantcall][:bowtie2][:zip]       = "bowtie2-#{node[:saasfee][:variantcall][:bowtie2][:version]}-linux-x86_64.zip"
default[:saasfee][:variantcall][:bowtie2][:home]      = "#{node[:saasfee][:software][:dir]}/bowtie2-#{node[:saasfee][:variantcall][:bowtie2][:version]}"
default[:saasfee][:variantcall][:bowtie2][:url]       = "http://downloads.sourceforge.net/project/bowtie-bio/bowtie2/#{node[:saasfee][:variantcall][:bowtie2][:version]}/#{node[:saasfee][:variantcall][:bowtie2][:zip]}"
default[:saasfee][:variantcall][:bwa][:version]       = "0.7.12"
default[:saasfee][:variantcall][:bwa][:tarbz2]        = "bwa-#{node[:saasfee][:variantcall][:bwa][:version]}.tar.bz2"
default[:saasfee][:variantcall][:bwa][:home]          = "#{node[:saasfee][:software][:dir]}/bwa-#{node[:saasfee][:variantcall][:bwa][:version]}"
default[:saasfee][:variantcall][:bwa][:url]           = "http://downloads.sourceforge.net/project/bio-bwa/#{node[:saasfee][:variantcall][:bwa][:tarbz2]}"
default[:saasfee][:variantcall][:samtools][:version]  = "1.2"
default[:saasfee][:variantcall][:samtools][:tarbz2]   = "samtools-#{node[:saasfee][:variantcall][:samtools][:version]}.tar.bz2"
default[:saasfee][:variantcall][:samtools][:home]     = "#{node[:saasfee][:software][:dir]}/samtools-#{node[:saasfee][:variantcall][:samtools][:version]}"
default[:saasfee][:variantcall][:samtools][:url]      = "http://download.sourceforge.net/project/samtools/samtools/#{node[:saasfee][:variantcall][:samtools][:version]}/#{node[:saasfee][:variantcall][:samtools][:tarbz2]}"
default[:saasfee][:variantcall][:varscan][:version]   = "2.3.7"
default[:saasfee][:variantcall][:varscan][:jar]       = "VarScan.v#{node[:saasfee][:variantcall][:varscan][:version]}.jar"
default[:saasfee][:variantcall][:varscan][:home]      = "#{node[:saasfee][:software][:dir]}/varscan-#{node[:saasfee][:variantcall][:samtools][:version]}"
default[:saasfee][:variantcall][:varscan][:url]       = "http://downloads.sourceforge.net/project/varscan/#{node[:saasfee][:variantcall][:varscan][:jar]}"
default[:saasfee][:variantcall][:annovar][:targz]     = "annovar.latest.tar.gz"
default[:saasfee][:variantcall][:annovar][:home]      = "#{node[:saasfee][:software][:dir]}/annovar"
default[:saasfee][:variantcall][:annovar][:url]       = "http://www.openbioinformatics.org/annovar/download/0wgxR2rIVP/#{node[:saasfee][:variantcall][:annovar][:targz]}"
default[:saasfee][:variantcall][:fastqc][:version]    = "0.11.4"
default[:saasfee][:variantcall][:fastqc][:zip]        = "fastqc_v#{node[:saasfee][:variantcall][:fastqc][:version]}.zip"
default[:saasfee][:variantcall][:fastqc][:home]       = "#{node[:saasfee][:software][:dir]}/FastQC"
default[:saasfee][:variantcall][:fastqc][:url]        = "http://www.bioinformatics.babraham.ac.uk/projects/fastqc/#{node[:saasfee][:variantcall][:fastqc][:zip]}"

default[:saasfee][:variantcall][:scale][:workflow]    = "variantcall-scale.cf"
default[:saasfee][:variantcall][:scale][:url]         = "https://s3.amazonaws.com/variantcall-scale/hg19.tar.gz"
default[:saasfee][:variantcall][:scale][:data]        = "#{node[:saasfee][:data]}/hg19"
default[:saasfee][:variantcall][:scale][:index]       = "#{node[:saasfee][:variantcall][:scale][:data]}/hg19"
default[:saasfee][:variantcall][:scale][:fa]          = "#{node[:saasfee][:variantcall][:scale][:data]}/hg19.fa"
default[:saasfee][:variantcall][:scale][:db]          = "#{node[:saasfee][:variantcall][:scale][:data]}/db"
default[:saasfee][:variantcall][:scale][:nsamples]    = "1"
default[:saasfee][:variantcall][:scale][:gz]          = { "HG00410" => ["SRR593645", "SRR592217", "SRR593334", "SRR594082", "SRR593671", "SRR593703", "SRR593677", "SRR593991"],
                                                          "NA12546" => ["ERR243808", "ERR244870", "ERR244852", "ERR243129", "ERR244933", "ERR244891", "ERR244831", "ERR243829"],
                                                          "HG02601" => ["SRR588625", "SRR588800", "SRR589008", "SRR589618", "SRR590374", "SRR590176", "SRR590556", "SRR588615"],
                                                          "HG02676" => ["SRR583496", "SRR583998", "SRR584544", "SRR583694", "SRR582367", "SRR587777", "SRR584237", "SRR587265"],
                                                          "NA20809" => ["ERR244591", "ERR244671", "ERR244551", "ERR244511", "ERR242686", "ERR244711", "ERR244471", "ERR244431"],
                                                          "NA20522" => ["ERR244720", "ERR244680", "ERR244600", "ERR244560", "ERR244520", "ERR242695", "ERR244480", "ERR242734"],
                                                          "NA20535" => ["ERR241394", "ERR242930", "ERR242891", "ERR244818", "ERR241314", "ERR241354", "ERR241434", "ERR242854"],
                                                          "HG01864" => ["SRR395973", "SRR360061", "SRR360238", "SRR359804", "SRR359838", "SRR361110", "SRR360240", "SRR360025"],
                                                          "HG02725" => ["SRR590517", "SRR590348", "SRR588810", "SRR589868", "SRR590662", "SRR590486", "SRR590611", "SRR588565"],
                                                          "HG03452" => ["SRR591397", "SRR591562", "SRR591056", "SRR591163", "SRR591079", "SRR591701", "SRR591334", "SRR591120"],
                                                          "HG02621" => ["SRR587967", "SRR588160", "SRR585021", "SRR583049", "SRR583959", "SRR584846", "SRR587629", "SRR584986"],
                                                          "NA20524" => ["ERR242017", "ERR242097", "ERR241817", "ERR241857", "ERR241897", "ERR242577", "ERR241937", "ERR241977"],
                                                          "NA19019" => ["SRR605047", "SRR604633", "SRR604953", "SRR604776", "SRR604920", "SRR605251", "SRR604888", "SRR605154"],
                                                          "HG02025" => ["SRR360044", "SRR359822", "SRR395026", "SRR363073", "SRR360051", "SRR360222", "SRR396040", "SRR359188"],
                                                          "HG02783" => ["SRR589896", "SRR588704", "SRR588500", "SRR589848", "SRR589087", "SRR590464", "SRR589937", "SRR590440"],
                                                          "HG02461" => ["SRR587726", "SRR587885", "SRR587987", "SRR582484", "SRR583499", "SRR584509", "SRR587563", "SRR587564"],
                                                          "HG00598" => ["SRR593463", "SRR594028", "SRR593478", "SRR593510", "SRR593679", "SRR592235", "SRR594001", "SRR593911"],
                                                          "HG03124" => ["SRR594788", "SRR594282", "SRR628608", "SRR594931", "SRR594349", "SRR594205", "SRR594946", "SRR594263"],
                                                          "HG00623" => ["SRR593536", "SRR593754", "SRR593482", "SRR592212", "SRR594047", "SRR593913", "SRR593877", "SRR593989"],
                                                          "NA19024" => ["SRR604978", "SRR604879", "SRR604851", "SRR605348", "SRR605354", "SRR605357", "SRR604837", "SRR604623"],
                                                          "NA20517" => ["ERR242694", "ERR244719", "ERR244679", "ERR244599", "ERR244559", "ERR244519", "ERR244639", "ERR244479"],
                                                          "HG02974" => ["SRR594720", "SRR628623", "SRR606168", "SRR596095", "SRR596621", "SRR594699", "SRR596128", "SRR594629"],
                                                          "HG02721" => ["SRR583052", "SRR587879", "SRR583497", "SRR588048", "SRR586306", "SRR582689", "SRR584560", "SRR583929"],
                                                          "HG01869" => ["SRR360024", "SRR360218", "SRR363062", "SRR360043", "SRR359823", "SRR396030", "SRR359189", "SRR360039"],
                                                          "HG02654" => ["SRR589435", "SRR590362", "SRR590027", "SRR590583", "SRR589709", "SRR589928", "SRR590578", "SRR589027"],
                                                          "HG00599" => ["SRR593767", "SRR593970", "SRR592150", "SRR592151", "SRR593940", "SRR592223", "SRR593814", "SRR593418"],
                                                          "HG02722" => ["SRR585113", "SRR587267", "SRR587671", "SRR582219", "SRR587542", "SRR586844", "SRR585161", "SRR583349"],
                                                          "HG00675" => ["SRR593905", "SRR593770", "SRR593659", "SRR593447", "SRR593545", "SRR593359", "SRR593643", "SRR593685"],
                                                          "HG02787" => ["SRR590328", "SRR590428", "SRR588912", "SRR590213", "SRR590573", "SRR590493", "SRR590421", "SRR590505"],
                                                          "HG01945" => ["SRR360286", "SRR361912", "SRR360070", "SRR359242", "SRR360261", "SRR361901", "SRR360093", "SRR398866"],
                                                          "HG02588" => ["SRR581323", "SRR580597", "SRR582025", "SRR581778", "SRR581599", "SRR581161", "SRR581302", "SRR580955"],
                                                          "HG01885" => ["SRR396687", "SRR396723", "SRR396692", "SRR396688", "SRR396695", "SRR396693", "SRR394094", "SRR396685"],
                                                          "HG03049" => ["SRR584462", "SRR583670", "SRR583147", "SRR582914", "SRR584466", "SRR587561", "SRR583911", "SRR582179"],
                                                          "HG02600" => ["SRR590205", "SRR589432", "SRR588710", "SRR589869", "SRR590256", "SRR588909", "SRR589271", "SRR589652"],
                                                          "HG02620" => ["SRR587764", "SRR587382", "SRR583379", "SRR725509", "SRR583179", "SRR584703", "SRR584537", "SRR582604"],
                                                          "NA12383" => ["ERR243702", "ERR243303", "ERR243723", "ERR243408", "ERR243660", "ERR243681", "ERR243324", "ERR243450"],
                                                          "NA07000" => ["ERR243645", "ERR243771", "ERR243687", "ERR243750", "ERR243666", "ERR243729", "ERR243708", "ERR243309"],
                                                          "HG02811" => ["SRR581775", "SRR581984", "SRR581156", "SRR581847", "SRR580982", "SRR581057", "SRR581169", "SRR581268"],
                                                          "HG02464" => ["SRR583939", "SRR586237", "SRR584581", "SRR586823", "SRR583664", "SRR582899", "SRR587387", "SRR585241"],
                                                          "HG01710" => ["SRR360741", "SRR358928", "SRR360931", "SRR394772", "SRR360735", "SRR358912", "SRR360002", "SRR394586"],
                                                          "HG02696" => ["SRR589594", "SRR589744", "SRR590384", "SRR590054", "SRR588783", "SRR588585", "SRR589232", "SRR590034"],
                                                          "HG01865" => ["SRR363052", "SRR359817", "SRR361119", "SRR360053", "SRR396091", "SRR395960", "SRR361114", "SRR363063"],
                                                          "NA21137" => ["SRR362778", "SRR362198", "SRR362796", "SRR363107", "SRR361979", "SRR362927", "SRR363020", "SRR359866"],
                                                          "NA20871" => ["SRR362223", "SRR360156", "SRR363019", "SRR359157", "SRR359895", "SRR362931", "SRR362891", "SRR362085"],
                                                          "NA20888" => ["SRR396391", "SRR362765", "SRR363026", "SRR362201", "SRR362933", "SRR395365", "SRR359879", "SRR396468"],
                                                          "HG02789" => ["SRR589843", "SRR590729", "SRR588932", "SRR589020", "SRR588975", "SRR588676", "SRR590705", "SRR590375"],
                                                          "HG02678" => ["SRR582578", "SRR584018", "SRR583866", "SRR588179", "SRR582424", "SRR588335", "SRR587443", "SRR584155"],
                                                          "HG01935" => ["SRR360074", "SRR361950", "SRR360083", "SRR360275", "SRR360247", "SRR359221", "SRR359212", "SRR363108"],
                                                          "HG02799" => ["SRR584410", "SRR583732", "SRR588245", "SRR585243", "SRR585261", "SRR587769", "SRR584816", "SRR584842"],
                                                          "HG00674" => ["SRR593909", "SRR593615", "SRR594065", "SRR593978", "SRR592246", "SRR593650", "SRR594022", "SRR594015"],
                                                          "NA12348" => ["ERR243470", "ERR243575", "ERR243554", "ERR243512", "ERR243617", "ERR243596", "ERR243428", "ERR243386"],
                                                          "HG03469" => ["SRR591918", "SRR591818", "SRR592012", "SRR591820", "SRR591929", "SRR591995", "SRR591840", "SRR591812"],
                                                          "NA20858" => ["SRR359875", "SRR362115", "SRR362030", "SRR362149", "SRR362936", "SRR359124", "SRR362230", "SRR360159"],
                                                          "HG02702" => ["SRR584211", "SRR583551", "SRR587576", "SRR583770", "SRR583218", "SRR584500", "SRR584494", "SRR583224"],
                                                          "NA20872" => ["SRR359119", "SRR359138", "SRR359129", "SRR359147", "SRR359118", "SRR359151", "SRR359162", "SRR359150"],
                                                          "HG02922" => ["SRR595978", "SRR594128", "SRR594734", "SRR594840", "SRR594303", "SRR594555", "SRR594660", "SRR596552"],
                                                          "HG02784" => ["SRR590296", "SRR588725", "SRR589814", "SRR590352", "SRR588734", "SRR589732", "SRR590643", "SRR589694"],
                                                          "HG00409" => ["SRR592173", "SRR593471", "SRR593668", "SRR594064", "SRR594107", "SRR593839", "SRR593951", "SRR594052"],
                                                          "HG02724" => ["SRR590609", "SRR590445", "SRR590266", "SRR590430", "SRR588977", "SRR590529", "SRR588899", "SRR589635"],
                                                          "NA20870" => ["SRR362094", "SRR360185", "SRR359161", "SRR362168", "SRR362141", "SRR360174", "SRR363007", "SRR362944"],
                                                          "HG02658" => ["SRR589776", "SRR588563", "SRR588907", "SRR589106", "SRR588796", "SRR588906", "SRR590129", "SRR588570"],
                                                          "HG03039" => ["SRR587685", "SRR587360", "SRR587457", "SRR588289", "SRR584818", "SRR584433", "SRR582611", "SRR583686"],
                                                          "NA19017" => ["SRR605068", "SRR604993", "SRR604803", "SRR604853", "SRR604648", "SRR604883", "SRR604828", "SRR605034"],
                                                          "NA20518" => ["ERR242111", "ERR242031", "ERR241951", "ERR241911", "ERR242311", "ERR241871", "ERR242271", "ERR242071"],
                                                          "HG02645" => ["SRR584249", "SRR584364", "SRR582248", "SRR587527", "SRR587427", "SRR585210", "SRR583749", "SRR582692"],
                                                          "HG02734" => ["SRR590246", "SRR590795", "SRR589530", "SRR590697", "SRR589357", "SRR590498", "SRR590097", "SRR588921"],
                                                          "NA12347" => ["ERR243469", "ERR243427", "ERR243385", "ERR243364", "ERR243343", "ERR243574", "ERR243448", "ERR243322"],
                                                          "HG02733" => ["SRR589223", "SRR589570", "SRR589566", "SRR590527", "SRR590588", "SRR589714", "SRR589004", "SRR589725"],
                                                          "NA20910" => ["SRR359484", "SRR362151", "SRR360434", "SRR359354", "SRR363105", "SRR362870", "SRR362106", "SRR362025"],
                                                          "HG02687" => ["SRR589926", "SRR588945", "SRR588649", "SRR589631", "SRR590508", "SRR589872", "SRR589525", "SRR589222"],
                                                          "NA12778" => ["ERR243769", "ERR243643", "ERR243748", "ERR243685", "ERR243664", "ERR243727", "ERR243706", "ERR243307"],
                                                          "HG02769" => ["SRR581642", "SRR581792", "SRR582047", "SRR582067", "SRR582081", "SRR581960", "SRR581345", "SRR581202"],
                                                          "NA20890" => ["SRR396229", "SRR363010", "SRR396339", "SRR396220", "SRR362235", "SRR362823", "SRR362878", "SRR359865"],
                                                          "HG02805" => ["SRR581427", "SRR582163", "SRR581343", "SRR581181", "SRR582018", "SRR581109", "SRR580960", "SRR581983"],
                                                          "HG04035" => ["SRR788944", "SRR789035", "SRR789568", "SRR789566", "SRR789207", "SRR789370", "SRR789662", "SRR789687"],
                                                          "HG01944" => ["SRR359227", "SRR361975", "SRR360280", "SRR359237", "SRR360108", "SRR395718", "SRR361916", "SRR361895"],
                                                          "NA20506" => ["ERR242649", "ERR242449", "ERR244753", "ERR242529", "ERR242489", "ERR242609", "ERR242569", "ERR241809"],
                                                          "NA20895" => ["SRR362988", "SRR362790", "SRR362833", "SRR359465", "SRR362032", "SRR359456", "SRR362926", "SRR359873"],
                                                          "HG03058" => ["SRR591689", "SRR591336", "SRR591191", "SRR591380", "SRR591748", "SRR591193", "SRR591580", "SRR591349"],
                                                          "NA21126" => ["SRR605466", "SRR606180", "SRR605399", "SRR605273", "SRR605205", "SRR605572", "SRR605556", "SRR605473"],
                                                          "HG02585" => ["SRR581349", "SRR581348", "SRR581249", "SRR581574", "SRR581491", "SRR580601", "SRR581422", "SRR581415"],
                                                          "HG02661" => ["SRR589513", "SRR590598", "SRR589608", "SRR588503", "SRR590172", "SRR589967", "SRR589287", "SRR588599"],
                                                          "HG01709" => ["SRR359177", "SRR394787", "SRR360722", "SRR394768", "SRR394747", "SRR394764", "SRR394826", "SRR394588"],
                                                          "HG02786" => ["SRR590251", "SRR590548", "SRR589337", "SRR589847", "SRR590450", "SRR590300", "SRR590121", "SRR588659"],
                                                          "NA19792" => ["SRR605179", "SRR605157", "SRR604606", "SRR604834", "SRR604950", "SRR605055", "SRR604615", "SRR605250"],
                                                          "HG02666" => ["SRR582256", "SRR584288", "SRR582950", "SRR582762", "SRR585204", "SRR584849", "SRR583415", "SRR587407"],
                                                          "NA20755" => ["ERR242639", "ERR242439", "ERR244743", "ERR242519", "ERR242479", "ERR242599", "ERR242559", "ERR241799"],
                                                          "HG02790" => ["SRR590756", "SRR589085", "SRR590143", "SRR589764", "SRR588651", "SRR590166", "SRR589354", "SRR589451"],
                                                          "HG01708" => ["SRR360729", "SRR395878", "SRR395882", "SRR395860", "SRR395864", "SRR360894", "SRR358934", "SRR360927"],
                                                          "HG01863" => ["SRR394973", "SRR395924", "SRR359397", "SRR394993", "SRR359392", "SRR359370", "SRR359394", "SRR359375"],
                                                          "HG01939" => ["SRR358884", "SRR360111", "SRR360097", "SRR360267", "SRR398809", "SRR394508", "SRR361944", "SRR363111"],
                                                          "NA20906" => ["SRR362980", "SRR396290", "SRR362785", "SRR362206", "SRR362928", "SRR359867", "SRR363018", "SRR360188"],
                                                          "HG01704" => ["SRR394591", "SRR360723", "SRR395821", "SRR358943", "SRR394784", "SRR359173", "SRR395805", "SRR394774"],
                                                          "NA20891" => ["SRR396212", "SRR396415", "SRR363021", "SRR396250", "SRR362236", "SRR359902", "SRR362841", "SRR362166"],
                                                          "HG00622" => ["SRR593726", "SRR594163", "SRR593639", "SRR593894", "SRR593556", "SRR593601", "SRR592174", "SRR593845"],
                                                          "NA18980" => ["ERR240234", "ERR240144", "ERR240159", "ERR240174", "ERR240219", "ERR240204", "ERR240189", "ERR239979"],
                                                          "NA20542" => ["ERR242664", "ERR242464", "ERR244768", "ERR242504", "ERR242544", "ERR242624", "ERR241824", "ERR242584"],
                                                          "HG00729" => ["SRR593820", "SRR593526", "SRR592156", "SRR592095", "SRR593841", "SRR593542", "SRR593985", "SRR593465"],
                                                          "HG02491" => ["SRR590182", "SRR589338", "SRR588817", "SRR590035", "SRR589327", "SRR589041", "SRR589509", "SRR590478"],
                                                          "HG02571" => ["SRR581966", "SRR581561", "SRR581368", "SRR581201", "SRR581811", "SRR582149", "SRR580615", "SRR581359"],
                                                          "HG02768" => ["SRR581745", "SRR581684", "SRR581304", "SRR581857", "SRR580963", "SRR582106", "SRR581724", "SRR581877"],
                                                          "HG03259" => ["SRR580999", "SRR580989", "SRR581075", "SRR580968", "SRR581627", "SRR581166", "SRR581886", "SRR580944"],
                                                          "HG01926" => ["SRR361964", "SRR361951", "SRR394477", "SRR395784", "SRR359255", "SRR358888", "SRR360118", "SRR395798"],
                                                          "HG01950" => ["SRR395723", "SRR398818", "SRR395796", "SRR398765", "SRR394459", "SRR394551", "SRR398785", "SRR394493"],
                                                          "HG03135" => ["SRR594356", "SRR596202", "SRR596139", "SRR596463", "SRR596610", "SRR596540", "SRR594382", "SRR596077"],
                                                          "NA20892" => ["SRR396408", "SRR395322", "SRR395361", "SRR396363", "SRR395221", "SRR396249", "SRR396498", "SRR396462"],
                                                          "HG04042" => ["SRR789405", "SRR789283", "SRR789650", "SRR789604", "SRR788862", "SRR789556", "SRR789145", "SRR789381"],
                                                          "HG00631" => ["SRR593736", "SRR592249", "SRR592248", "SRR606931", "SRR592100", "SRR593791", "SRR593730", "SRR593729"],
                                                          "HG03451" => ["SRR591989", "SRR592046", "SRR592008", "SRR591817", "SRR591898", "SRR592033", "SRR591996", "SRR592018"],
                                                          "HG02697" => ["SRR590193", "SRR588869", "SRR590399", "SRR589561", "SRR590390", "SRR588499", "SRR590610", "SRR588922"],
                                                          "NA20896" => ["SRR396271", "SRR395368", "SRR395340", "SRR362986", "SRR395261", "SRR362818", "SRR362816", "SRR362204"],
                                                          "HG04025" => ["SRR793772", "SRR795393", "SRR795354", "SRR790877", "SRR793918", "SRR795366", "SRR792115", "SRR792472"],
                                                          "NA20911" => ["SRR396252", "SRR396278", "SRR395326", "SRR396824", "SRR395243", "SRR396377", "SRR396134", "SRR395433"],
                                                          "HG01747" => ["SRR394801", "SRR395880", "SRR395802", "SRR395908", "SRR395846", "SRR360736", "SRR395813", "SRR395888"],
                                                          "NA20875" => ["SRR362965", "SRR362244", "SRR362772", "SRR362894", "SRR359891", "SRR362023", "SRR362972", "SRR362126"],
                                                          "NA20874" => ["SRR363033", "SRR362211", "SRR362263", "SRR362859", "SRR362112", "SRR362900", "SRR361980", "SRR362082"],
                                                          "NA20908" => ["SRR396144", "SRR395181", "SRR396115", "SRR396109", "SRR395187", "SRR359346", "SRR395175", "SRR359330"],
                                                          "NA20849" => ["SRR363000", "SRR362185", "SRR362809", "SRR362884", "SRR359446", "SRR362921", "SRR361990", "SRR359874"],
                                                          "HG03897" => ["SRR788963", "SRR788965", "SRR789321", "SRR788971", "SRR789564", "SRR789499", "SRR789312", "SRR789071"],
                                                          "HG01705" => ["SRR395900", "SRR394765", "SRR360731", "SRR394827", "SRR394749", "SRR358944", "SRR358932", "SRR395857"],
                                                          "HG04106" => ["SRR788815", "SRR788936", "SRR789262", "SRR789129", "SRR789337", "SRR789222", "SRR788746", "SRR789630"],
                                                          "HG04020" => ["SRR793572", "SRR791802", "SRR794584", "SRR790470", "SRR790520", "SRR790508", "SRR791037", "SRR793911"],
                                                          "NA21129" => ["SRR605313", "SRR605469", "SRR605470", "SRR605436", "SRR605243", "SRR605266", "SRR605573", "SRR605445"],
                                                          "NA20902" => ["SRR395367", "SRR395276", "SRR396424", "SRR395355", "SRR395253", "SRR396335", "SRR395453", "SRR395220"],
                                                          "NA12777" => ["ERR243102", "ERR243789", "ERR244977", "ERR244956", "ERR244893", "ERR244914", "ERR244872", "ERR243810"],
                                                          "HG01866" => ["SRR360235", "SRR360056", "SRR359841", "SRR360206", "SRR359807", "SRR360241", "SRR361122", "SRR363075"],
                                                          "HG01936" => ["SRR395758", "SRR398787", "SRR398843", "SRR398778", "SRR394428", "SRR396832", "SRR395746", "SRR394567"],
                                                          "HG03851" => ["SRR789140", "SRR789500", "SRR789547", "SRR788887", "SRR789402", "SRR789180", "SRR789364", "SRR788879"] }

default[:saasfee][:montage][:degree] = "0.5"
default[:saasfee][:montage][:region] = "M17"
default[:saasfee][:montage][:version] = "4.0"
default[:saasfee][:montage][:targz] = "Montage_v#{node[:saasfee][:montage][:version]}.tar.gz"
default[:saasfee][:montage][:home] = "#{node[:saasfee][:software][:dir]}/montage"
default[:saasfee][:montage][:url] = "http://montage.ipac.caltech.edu/download/#{node[:saasfee][:montage][:targz]}"

default[:saasfee][:montage_synthetic][:workflow]       = "Montage_25.xml"
default[:saasfee][:montage_synthetic][:url]            = "https://confluence.pegasus.isi.edu/download/attachments/2490624/#{node[:saasfee][:montage_synthetic][:workflow]}"

default[:saasfee][:galaxy101][:workflow]               = "galaxy101.ga"
default[:saasfee][:galaxy101][:exons][:bed]            = "Exons.bed"
default[:saasfee][:galaxy101][:exons][:targz]          = "#{node[:saasfee][:galaxy101][:exons][:bed]}.tar.gz"
default[:saasfee][:galaxy101][:snps][:bed]             = "SNPs.bed"
default[:saasfee][:galaxy101][:snps][:targz]           = "#{node[:saasfee][:galaxy101][:snps][:bed]}.tar.gz"
default[:saasfee][:galaxy101][:join][:name]            = "join"
default[:saasfee][:galaxy101][:join][:revision]        = "de21bdbb8d28"

default[:saasfee][:RNAseq][:workflow]                            = "RNAseq.ga"
default[:saasfee][:RNAseq][:ref_annotation][:gtf]                = "mm9_ref_annotation.gtf"
default[:saasfee][:RNAseq][:ref_annotation][:targz]              = "#{node[:saasfee][:RNAseq][:ref_annotation][:gtf]}.tar.gz"
default[:saasfee][:RNAseq][:sratoolkit][:version]                = "2.4.5-2"
default[:saasfee][:RNAseq][:sratoolkit][:targz]                  = "sratoolkit.#{node[:saasfee][:RNAseq][:sratoolkit][:version]}-ubuntu64.tar.gz"
default[:saasfee][:RNAseq][:sratoolkit][:home]                   = "#{node[:saasfee][:software][:dir]}/sratoolkit.#{node[:saasfee][:RNAseq][:sratoolkit][:version]}-ubuntu64"
default[:saasfee][:RNAseq][:sratoolkit][:url]                    = "http://ftp-trace.ncbi.nlm.nih.gov/sra/sdk/#{node[:saasfee][:RNAseq][:sratoolkit][:version]}/#{node[:saasfee][:RNAseq][:sratoolkit][:targz]}"
default[:saasfee][:RNAseq][:input1][:replicate1][:accession]    = "SRR1632911"
default[:saasfee][:RNAseq][:input1][:replicate1][:fastq]        = "GSM1533014_MD_O1_WT_Colon.fastqsanger"
default[:saasfee][:RNAseq][:input1][:replicate2][:accession]    = "SRR1632912"
default[:saasfee][:RNAseq][:input1][:replicate2][:fastq]        = "GSM1533015_MD_O2_WT_Colon.fastqsanger"
default[:saasfee][:RNAseq][:input1][:replicate3][:accession]    = "SRR1632913"
default[:saasfee][:RNAseq][:input1][:replicate3][:fastq]        = "GSM1533016_MD_O3_WT_Colon.fastqsanger"
default[:saasfee][:RNAseq][:input2][:replicate1][:accession]    = "SRR1632942"
default[:saasfee][:RNAseq][:input2][:replicate1][:fastq]        = "GSM1533045_MD_Y1_WT_Colon.fastqsanger"
default[:saasfee][:RNAseq][:input2][:replicate2][:accession]    = "SRR1632943"
default[:saasfee][:RNAseq][:input2][:replicate2][:fastq]        = "GSM1533046_MD_Y2_WT_Colon.fastqsanger"
default[:saasfee][:RNAseq][:input2][:replicate3][:accession]    = "SRR1632944"
default[:saasfee][:RNAseq][:input2][:replicate3][:fastq]        = "GSM1533047_MD_Y3_WT_Colon.fastqsanger"
default[:saasfee][:RNAseq][:fastq_trimmer_by_quality][:name]     = "fastq_trimmer_by_quality"
default[:saasfee][:RNAseq][:fastq_trimmer_by_quality][:revision] = "1cdcaf5fc1da"
default[:saasfee][:RNAseq][:fastqc][:name]                       = "fastqc"
default[:saasfee][:RNAseq][:fastqc][:revision]                   = "e28c965eeed4"
default[:saasfee][:RNAseq][:fastx_clipper][:name]                = "fastx_clipper"
default[:saasfee][:RNAseq][:fastx_clipper][:revision]            = "8192b4014977"
default[:saasfee][:RNAseq][:tophat2][:name]                      = "tophat2"
default[:saasfee][:RNAseq][:tophat2][:revision]                  = "ae06af1118dc"
default[:saasfee][:RNAseq][:picard][:name]                       = "picard"
default[:saasfee][:RNAseq][:picard][:revision]                   = "ab1f60c26526"
default[:saasfee][:RNAseq][:cufflinks][:name]                    = "cufflinks"
default[:saasfee][:RNAseq][:cufflinks][:revision]                = "9aab29e159a7"
default[:saasfee][:RNAseq][:cuffmerge][:name]                    = "cuffmerge"
default[:saasfee][:RNAseq][:cuffmerge][:revision]                = "424d49834830"
default[:saasfee][:RNAseq][:cuffcompare][:name]                  = "cuffcompare"
default[:saasfee][:RNAseq][:cuffcompare][:revision]              = "67695d7ff787"
default[:saasfee][:RNAseq][:cuffdiff][:name]                     = "cuffdiff"
default[:saasfee][:RNAseq][:cuffdiff][:revision]                 = "604fa75232a2"
default[:saasfee][:RNAseq][:column_maker][:name]                 = "column_maker"
default[:saasfee][:RNAseq][:column_maker][:revision]             = "08a01b2ce4cd"
