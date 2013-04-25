require 'test/unit'
require 'FileUtils'
require_relative '../src/FxCop'

class TestFxCop < Test::Unit::TestCase
	OUTPUT_FILE_NAME = File.expand_path("output.xml")
	FXCOP_BINARY = 'C:\workspace\playpit\FxCop\FxCopCmd.exe'	

	def test_when_fxcop_run_against_clean_and_dirty_assembly_then_output_file_created
		dirty_assembly = File.expand_path("FxCopDirtyDLL.dll")
		clean_assembly = File.expand_path("FxCopCleanDLL.dll")
		FileUtils.rm_f(OUTPUT_FILE_NAME)
		fxcop_settings = BuildQuality::FxCopSettings.new(
			assemblies: [dirty_assembly,clean_assembly],
			output_file_name: OUTPUT_FILE_NAME
		)	
		BuildQuality::FxCop.new(self,fxcop_binary: FXCOP_BINARY).start(fxcop_settings)
		assert_equal(true,File.exists?(OUTPUT_FILE_NAME))
	end

	def test_when_fxcop_run_against_clean_assembly_then_no_output_file_created
		clean_assembly = File.expand_path("FxCopCleanDLL.dll")
		FileUtils.rm_f(OUTPUT_FILE_NAME)
		fxcop_settings = BuildQuality::FxCopSettings.new(
			assemblies: [clean_assembly],
			output_file_name: OUTPUT_FILE_NAME
		)	
		BuildQuality::FxCop.new(self,fxcop_binary: FXCOP_BINARY).start(fxcop_settings)
		assert_equal(false,File.exists?(OUTPUT_FILE_NAME))
	end

	def test_when_fxcop_run_against_dirty_assembly_then_output_file_created
		dirty_assembly = File.expand_path("FxCopDirtyDLL.dll")
		FileUtils.rm_f(OUTPUT_FILE_NAME)
		fxcop_settings = BuildQuality::FxCopSettings.new(
			assemblies: [dirty_assembly],
			output_file_name: OUTPUT_FILE_NAME
		)	
		BuildQuality::FxCop.new(self,fxcop_binary: FXCOP_BINARY).start(fxcop_settings)
		assert_equal(true,File.exists?(OUTPUT_FILE_NAME))
	end

	def execute(command)
		puts command
		BuildQuality::ShellCommand.new.execute(command)
	end
end