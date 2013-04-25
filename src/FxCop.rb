module BuildQuality
	class FxCop
		def initialize(shell_command = ShellCommand.new, parameters)	
			fxcop_binary = parameters[:fxcop_binary]
			@fxcop_command = FxCopCommand.new(fxcop_binary,shell_command)			
			@fxCop_arguments_factory = FxCopArgumentsFactory.new
		end

		def start(fxcop_settings = FxCopSettings.new)									
			fxcop_arguments = @fxCop_arguments_factory.create(fxcop_settings)
			@fxcop_command.execute(fxcop_arguments)
		end		
	end

	class FxCopSettings
		attr_reader :assemblies, :output_file_name

		def initialize(parameters = {})
			@assemblies = parameters[:assemblies]
			@output_file_name = parameters[:output_file_name]
		end
	end

	class FxCopArgumentsFactory
		def initialize
			@output_argument_builder = OutputArgumentBuilder.new
			@file_arguments_builder = FileArgumentsBuilder.new
		end

		def create(fxcop_settings)
			file_arguments = @file_arguments_builder.build(fxcop_settings.assemblies)
			output_argument = @output_argument_builder.build(fxcop_settings.output_file_name)
			fxcop_arguments = FxCopArguments.new(file_arguments, output_argument)	
		end
	end

	class FxCopCommand		
		def initialize(fxcop_binary,shell_command)
			@fxcop_binary = fxcop_binary
			@shell_command = shell_command
		end

		def execute(fxcop_arguments)			
			fxcop_command = "#{@fxcop_binary}#{fxcop_arguments.file_arguments}#{fxcop_arguments.output_argument}"			
			@shell_command.execute(fxcop_command)
		end		
	end

	class FxCopArguments
		attr_reader :file_arguments, :output_argument

		def initialize(file_arguments, output_argument)
			@file_arguments = file_arguments
			@output_argument = output_argument
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
			# `#{command}`
			system command
		end
	end
end