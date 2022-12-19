if ENV['COVERAGE'] == 'true'
	require 'simplecov_json_formatter'
	require 'simplecov-html'
	SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new([
		SimpleCov::Formatter::JSONFormatter,
		SimpleCov::Formatter::HTMLFormatter
	])
	SimpleCov.coverage_dir('ci/ruby/coverage')
	# Ignore rake tasks and bin executables
	SimpleCov.add_filter ['lib/tasks', 'bin']
	SimpleCov.start 'rails'
	puts "required simplecov"
end
