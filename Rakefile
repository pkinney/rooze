require 'rake'
require 'rspec/core'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec) do |task|
  task.pattern = File.join(File.dirname(__FILE__), 'specs', '**', '*_spec.rb')
end
task :default => :spec
