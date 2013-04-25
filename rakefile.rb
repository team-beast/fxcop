task :default => [:dependencies, :unit_tests, :commit]

desc 'Load dependencies with bundler'
task :dependencies do
	system "bundle update"
end

desc 'Run unit tests'
task :unit_tests do
	require 'peach'
	TEST_FILE_PATTERN = 'tests/**/*.rb'
	Dir[TEST_FILE_PATTERN].peach do | test_file_name |
		puts ">> Running tests on: #{test_file_name}"
		system "ruby #{test_file_name}"
	end
end

desc 'Committing and Pushing to Git'
task :commit do	
	require 'git_repository'
	commit_message = ENV["m"] || 'no_commit_message'	
	git = GitRepository.new
	git.add
	git.commit(:message => commit_message)
	git.push	
end