require 'test/unit'
require_relative '../src/FxCop'
class TestFxCop < Test::Unit::TestCase
	def test_when_started_with_no_arguments_Then_command_is_fxcop_binary	
		fxcop_binary = '.\FxCopCmd.exe'
		BuildQuality::FxCop.new(self, fxcop_binary: fxcop_binary).start	
		assert_equal(fxcop_binary, @command)
	end	

	def test_when_fxcop_started_with_two_assemblies_Then_command_contains_both_assemblies_as_files_switches
		assembly1 = 'c:\workspace\mydll1.dll'
		assembly2 = 'c:\workspace\mydll2.dll'
		file_switch = '/f:'		
		fxcop_settings = BuildQuality::FxCopSettings.new(assemblies: [assembly1,assembly2])
		BuildQuality::FxCop.new(self, {}).start(fxcop_settings)
		assert_equal(" #{file_switch}#{assembly1} #{file_switch}#{assembly2}", @command)
	end

	def test_when_fxcop_started_with_out_file_name_provided_Then_command_contains_output_file_with_output_switch
		output_file_name = "fred.xml"
		output_switch = '/o:' 
		fxcop_settings = BuildQuality::FxCopSettings.new(output_file_name: output_file_name)
		BuildQuality::FxCop.new(self, {}).start(fxcop_settings)
		assert_equal(" #{output_switch}#{output_file_name}",@command)
	end

	def execute(command)
		@command = command
	end
end