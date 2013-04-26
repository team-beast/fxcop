module BuildQuality
	class FxCop
		def initialize(shell_command = ShellCommand.new, parameters)	
			fxcop_binary = parameters[:fxcop_binary]
			@fxcop_command = FxCopCommand.new(fxcop_binary,shell_command)	
			@fxcop_settings_adapter = FxCopSettingsAdapterFactory.new(@fxcop_command).create
		end

		def start(fxcop_settings = FxCopSettings.new)	
			@fxcop_settings_adapter.adapt(fxcop_settings)							
			@fxcop_command.execute
		end		
	end

	class FxCopSettings
		attr_reader :assemblies, :output_file_name, :dictionary_file_name, :ruleset_file_name, :culture

		def initialize(parameters = {})
			@assemblies = parameters[:assemblies] || []
			@output_file_name = parameters[:output_file_name]
			@dictionary_file_name = parameters[:dictionary_file_name]
			@ruleset_file_name = parameters[:ruleset_file_name]
			@culture = parameters[:culture]
		end
	end

	class FxCopSettingsAdapterFactory
		def initialize(fxcop_command)
			@fxcop_command = fxcop_command
		end

		def create
			culture_adapter = CultureAdapter.new(@fxcop_command)
			ruleset_file_name_adapter =  RulesetFileNameAdapter.new(@fxcop_command,culture_adapter)
			dictionary_file_name_adapter = DictionaryFileNameAdapter.new(@fxcop_command,ruleset_file_name_adapter)		
			assemblies_adapter = AssembliesAdapter.new(@fxcop_command, dictionary_file_name_adapter)
			OutputFileNameAdapter.new(@fxcop_command, assemblies_adapter)
		end
	end

	class FxCopCommand		
		def initialize(fxcop_binary,shell_command)
			@fxcop_binary = fxcop_binary
			@shell_command = shell_command
			@arguments = []
		end

		def execute					
			fxcop_command = "#{@fxcop_binary}" << @arguments.join			
			@shell_command.execute(fxcop_command)
		end			

		def add_argument(argument)			
			@arguments.push(argument)
		end
	end

	class OutputFileNameAdapter		
		OUTPUT_SWITCH = "/o:"
		def initialize(fxcop_command, next_adapter)			
			@fxcop_command = fxcop_command
			@next_adapter = next_adapter
		end

		def adapt(fxcop_settings)
			output_file_name = fxcop_settings.output_file_name
			output_argument = " #{OUTPUT_SWITCH}#{output_file_name}" unless output_file_name.nil?
			@fxcop_command.add_argument(output_argument)
			@next_adapter.adapt(fxcop_settings)
		end
	end

	class CultureAdapter
		CULTURE_SWITCH = ' /cul:'
		def initialize(fxcop_command)
			@fxcop_command = fxcop_command
		end

		def adapt(fxcop_settings)
			culture = fxcop_settings.culture
			@fxcop_command.add_argument("#{CULTURE_SWITCH}#{culture}") unless fxcop_settings.culture.nil?
		end
	end

	class RulesetFileNameAdapter
		RULESET_SWITCH = " /rs:="
		def initialize(fxcop_command, next_adapter)
			@fxcop_command = fxcop_command
			@next_adapter = next_adapter
		end
		def adapt(fxcop_settings)
			ruleset_file_name = fxcop_settings.ruleset_file_name
			@fxcop_command.add_argument("#{RULESET_SWITCH}#{ruleset_file_name}") unless ruleset_file_name.nil?
			@next_adapter.adapt(fxcop_settings)
		end
	end

	class DictionaryFileNameAdapter
		DICTIONARY_SWITCH = "/dic:"
		def initialize(fxcop_command, next_adapter)
			@next_adapter = next_adapter
			@fxcop_command = fxcop_command
		end
		def adapt(fxcop_settings)
			dictionary_file_name = fxcop_settings.dictionary_file_name
			dictionary_argument = " #{DICTIONARY_SWITCH}#{dictionary_file_name}" unless dictionary_file_name.nil?
			@fxcop_command.add_argument(dictionary_argument)
			@next_adapter.adapt(fxcop_settings)
		end
	end

	class AssembliesAdapter
		FILE_SWITCH = "/f:"

		def initialize(fxcop_command, next_adapter)
			@fxcop_command = fxcop_command
			@next_adapter = next_adapter
		end

		def adapt(fxcop_settings)			
			fxcop_settings.assemblies.each do | assembly |
				file_command = " #{FILE_SWITCH}#{assembly}"
				@fxcop_command.add_argument(file_command)
			end							
			@next_adapter.adapt(fxcop_settings)	
		end
	end

	class ShellCommand
		def execute(command)
			system command
		end
	end
end