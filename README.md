#FxCop


##Introduction

This gem allows execution of fxcop for use in rake tasks or standard ruby 

##Installation

The package is installed on rubygems and can be installed using the following command

    gem install 'fxcop'

or adding the following to your Gemfile
    
    gem 'fxcop'

You will need to insert the following command in your project `require 'fxcop`
or for usage in rake `require fxcop_raketask`

##Usage in Rake

The following is an example rakefile use of fxcop. Here output is put into the output.xml file which can be checked by the user or another rake task.

	require 'fxcop_raketask'
	fxcop :run_fxcop do |configuration|
		configuration.fxcop_binary = 'C:\workspace\playpit\FxCop\FxCopCmd.exe'
		configuration.assemblies = [File.expand_path("FxCopDirtyDLL.dll")]
		configuration.output_file_name = File.expand_path("output.xml")
		configuration.dictionary_file_name = File.expand_path("CustomDictionary.xml")
		configuration.ruleset_file_name = File.expand_path("testruleset.ruleset")
		configuration.culture = 'en-gb'
	end

##Usage in Standard Ruby

	assembly = File.expand_path("./bin/my_assembly.dll")
	FileUtils.rm_f(OUTPUT_FILE_NAME)
	system_wrapper = BuildQuality::ShellCommand.new
	fxcop_settings = BuildQuality::FxCopSettings.new(
			assemblies: [assembly],
			output_file_name: OUTPUT_FILE_NAME,
			dictionary_file_name: DICTIONARY_FILE_NAME,
			ruleset_file_name: RULESET_FILE_NAME,
			culture:'en-gb'
		)	
	BuildQuality::FxCop.new(system_wrapper,fxcop_binary: FXCOP_BINARY).start(fxcop_settings)

##Authors
###Ben Flowers

* Twitter: @BDWFlowers
* LinkedIn: [Ben Flowers](http://www.linkedin.com/pub/ben-flowers/41/414/3a4)
* Email: ben.j.flowers@gmail.com


###Iain Mitchell

* Twitter: @iainjmitchell
* LinkedIn: [Iain Mitchell](http://www.linkedin.com/pub/iain-mitchell/22/b29/b40)
* Email: iainjmitchell@gmail.com

###Rikk Renshaw

* Twitter: @rikk1982
* LinkedIn: [Richard Renshaw](http://www.linkedin.com/pub/richard-renshaw/37/879/372)
* Email: rikk62@gmail.com