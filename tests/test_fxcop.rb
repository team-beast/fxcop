require 'test/unit'

class TestFxCop < Test::Unit::TestCase
	def test_when_started_with_no_arguments_Then_command_is_fxcop_binary	
		fxcop_binary = '.\FxCopCmd.exe'
		FxCop.new(self, fxcop_binary: fxcop_binary).start	
		assert_equal(fxcop_binary, @command)
	end

	def test_when_started_with_assembly_argument_Then_command_is_file_switch_with_assembly	
		assembly = 'c:\workspace\mydll.dll'
		file_switch = '/f:'		
		FxCop.new(self,{}).start(assembly: assembly)	
		assert_equal("#{file_switch}#{assembly}", @command)
	end

	# def test_when_started_with_binary_and_assembly_arguments_Then_command_contains_both
	# 	assert_equal()
	# end

	def execute(command)
		@command = command
	end
end

class FxCop
	def initialize(shell_command, parameters)	
		fxcop_binary = parameters[:fxcop_binary]
		@fxcop_command = FxCopCommand.new(fxcop_binary,shell_command)
	end

	def start(parameters = {})
		file_command = FileCommandBuilder.build(parameters[:assembly])
		@fxcop_command.execute(file_command)
	end
end

class FxCopCommand
	def initialize(fxcop_binary,shell_command)
		@fxcop_binary = fxcop_binary
		@shell_command = shell_command
	end

	def execute(file_command)
		fxcop_command = "#{@fxcop_binary}#{file_command}"
		@shell_command.execute(fxcop_command)
	end
end

class FileCommandBuilder
	def self.build(assembly)
		"/f:#{assembly}" unless assembly.nil?
	end
end