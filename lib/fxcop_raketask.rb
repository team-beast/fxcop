require_relative "fxcop"

def fxcop(*args, &block)	
	fxcop_wrapper = FxCopWrapper.new(&block)
	task = Proc.new { fxcop_wrapper.run }
	Rake::Task.define_task(*args, &task)
end


class FxCopWrapper
	def initialize(&block)
		@block = block;
	end
	
	def run()			
		configuration = FxCopConfiguration.new
		@block.call(configuration)
		fxcop_settings = create_fxcop_settings_from_configuration(configuration)
		BuildQuality::FxCop.new(self,fxcop_binary: configuration.fxcop_binary).start(fxcop_settings)
	end

	def create_fxcop_settings_from_configuration(configuration)
		BuildQuality::FxCopSettings.new(assemblies: configuration.assemblies,
										output_file_name: configuration.output_file_name,
										dictionary_file_name: configuration.dictionary_file_name,
										ruleset_file_name: configuration.ruleset_file_name,
										culture: configuration.culture)
	end

	def execute(command)
		puts command
		BuildQuality::ShellCommand.new.execute(command)
	end
end

class FxCopConfiguration
	attr_accessor 	:fxcop_binary, 
					:assemblies,
					:output_file_name, 
					:dictionary_file_name, 
					:ruleset_file_name, 
					:culture
end