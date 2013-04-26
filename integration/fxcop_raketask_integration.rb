require 'test/unit'

# require_relative '../lib/fxcop_raketask'
require 'fxcop_raketask'
class TestFxCop < Test::Unit::TestCase
	require 'rake'
	OUTPUT_FILE_NAME = "output.xml"
	FXCOP_BINARY = 'C:\workspace\playpit\FxCop\FxCopCmd.exe'
	DICTIONARY_FILE_NAME = File.expand_path("./lib/CustomDictionary.xml")
	RULESET_FILE_NAME = File.expand_path("./lib/testruleset.ruleset")
	UK_CULTURE = 'en-gb'

	def test_when_fxcop_run_against_clean_and_dirty_assembly_in_rake_task_then_output_file_created
		
		dirty_assembly = File.expand_path("./bin/FxCopDirtyDLL.dll")
		clean_assembly = File.expand_path("./bin/FxCopCleanDLL.dll")
		
		fxcop :clean_and_dirty do |configuration|
			configuration.fxcop_binary = FXCOP_BINARY
			configuration.assemblies = [dirty_assembly,clean_assembly]
			configuration.output_file_name = File.expand_path(OUTPUT_FILE_NAME)
		end
		
		Rake::Task['clean_and_dirty'].invoke
		assert_equal(File.exists?(OUTPUT_FILE_NAME),true)
	end

	def test_when_fxcop_run_against_clean_assembly_then_no_output_file_created
	
		clean_assembly = File.expand_path("./bin/FxCopCleanDLL.dll")
		FileUtils.rm_f(OUTPUT_FILE_NAME)

		fxcop :clean do |configuration|
			configuration.fxcop_binary = FXCOP_BINARY
			configuration.assemblies = [clean_assembly]
			configuration.output_file_name = File.expand_path(OUTPUT_FILE_NAME)
		end
		
		Rake::Task['clean'].invoke	
		assert_equal(File.exists?(OUTPUT_FILE_NAME),false)
	end

	def test_when_fxcop_run_against_dirty_assembly_then_output_file_created
		dirty_assembly = File.expand_path("./bin/FxCopDirtyDLL.dll")
		FileUtils.rm_f(OUTPUT_FILE_NAME)
		fxcop :dirty do |configuration|
			configuration.fxcop_binary = FXCOP_BINARY
			configuration.assemblies = [dirty_assembly]
			configuration.output_file_name = File.expand_path(OUTPUT_FILE_NAME)
		end
		
		Rake::Task['dirty'].invoke	
		assert_equal(true,File.exists?(OUTPUT_FILE_NAME))
	end

	def test_when_fxcop_run_against_spelling_error_assembly_without_dictionary_then_output_file_created
		dirty_assembly = File.expand_path("./bin/FxCopSpellingErrorDll.dll")
		FileUtils.rm_f(OUTPUT_FILE_NAME)
		fxcop :spelling_error do |configuration|
			configuration.fxcop_binary = FXCOP_BINARY
			configuration.assemblies = [dirty_assembly]
			configuration.output_file_name = File.expand_path(OUTPUT_FILE_NAME)
		end
		
		Rake::Task['spelling_error'].invoke	
		assert_equal(File.exists?(OUTPUT_FILE_NAME),true)
	end

	def test_when_fxcop_run_against_spelling_error_assembly_with_dictionary_then_output_file_not_created
		dirty_assembly = File.expand_path("./bin/FxCopSpellingErrorDll.dll")
		FileUtils.rm_f(OUTPUT_FILE_NAME)
		fxcop :spelling_error_with_dictionary do |configuration|
			configuration.fxcop_binary = FXCOP_BINARY
			configuration.assemblies = [dirty_assembly]
			configuration.output_file_name = File.expand_path(OUTPUT_FILE_NAME)
			configuration.dictionary_file_name = DICTIONARY_FILE_NAME
		end
		Rake::Task['spelling_error_with_dictionary'].invoke	
		assert_equal(false,File.exists?(OUTPUT_FILE_NAME))
	end

	def test_when_fxcop_run_against_spelling_error_with_ruleset_then_output_file_created
		dirty_assembly = File.expand_path("./bin/FxCopSpellingErrorDll.dll")
		FileUtils.rm_f(OUTPUT_FILE_NAME)
		fxcop :spelling_error_with_ruleset do |configuration|
			configuration.fxcop_binary = FXCOP_BINARY
			configuration.assemblies = [dirty_assembly]
			configuration.output_file_name = File.expand_path(OUTPUT_FILE_NAME)
			configuration.ruleset_file_name = RULESET_FILE_NAME
		end
		Rake::Task['spelling_error_with_ruleset'].invoke	
		assert_equal(true, File.exists?(OUTPUT_FILE_NAME))
	end


	def test_when_fxcop_run_against_spelling_error_with_culture_then_output_file_not_created
		uk_spelling_assembly = File.expand_path("./bin/FxCopUKSpellingDll.dll")
		FileUtils.rm_f(OUTPUT_FILE_NAME)
		fxcop :spelling_error_with_culture do |configuration|
			configuration.fxcop_binary = FXCOP_BINARY
			configuration.assemblies = [uk_spelling_assembly]
			configuration.output_file_name = File.expand_path(OUTPUT_FILE_NAME)
			configuration.culture = UK_CULTURE
		end
		Rake::Task['spelling_error_with_culture'].invoke	
		assert_equal(false, File.exists?(OUTPUT_FILE_NAME))
	end
end