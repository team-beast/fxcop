require 'test/unit'

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
		BuildQuality::FxCop.new(self, {}).start(assemblies: [assembly1,assembly2])
		assert_equal(" #{file_switch}#{assembly1} #{file_switch}#{assembly2}", @command)
	end

	def test_when_fxcop_started_with_out_file_name_provided_Then_command_contains_output_file_with_output_switch
		output_file_name = "fred.xml"
		output_switch = '/o:' 
		BuildQuality::FxCop.new(self, {}).start(output_file_name: output_file_name)
		assert_equal(" #{output_switch}#{output_file_name}",@command)
	end

	def execute(command)
		@command = command
	end
end

module BuildQuality
	class FxCop
		def initialize(shell_command = ShellCommand.new, parameters)	
			fxcop_binary = parameters[:fxcop_binary]
			@fxcop_command = FxCopCommand.new(fxcop_binary,shell_command)
			@output_argument_builder = OutputArgumentBuilder.new
			@file_arguments_builder = FileArgumentsBuilder.new
		end

		def start(parameters = {})						
			file_command = @file_arguments_builder.build(parameters[:assemblies])
			output_command = @output_argument_builder.build(parameters[:output_file_name])
			@fxcop_command.execute(file_command,output_command)
		end
	end

	class FxCopCommand
		
		def initialize(fxcop_binary,shell_command)
			@fxcop_binary = fxcop_binary
			@shell_command = shell_command
		end

		def execute(file_command,output_command)			
			fxcop_command = "#{@fxcop_binary}#{file_command}#{output_command}"			
			@shell_command.execute(fxcop_command)
		end		
	end

	class OutputArgumentBuilder		
		OUTPUT_SWITCH = "/o:"

		def build(output_file_name)
			" #{OUTPUT_SWITCH}#{output_file_name}" unless output_file_name.nil?
		end
	end

	class FileArgumentsBuilder
		FILE_SWITCH = "/f:"

		def build(assemblies)			
			assemblies = [] if assemblies.nil?			
			file_commands = assemblies.map do | assembly |
				" #{FILE_SWITCH}#{assembly}"
			end						
			file_commands.join			
		end
	end

	class ShellCommand
		def execute(command)
			system command	
		end
	end
end