require "bundler/gem_tasks"
require "yard"
require 'rspec/core/rake_task'
require 'cucumber/rake/task'

YARD::Rake::YardocTask.new(:doc)
RSpec::Core::RakeTask.new(:spec) do |t|
  t.rspec_opts = '--color --format doc'
end
Cucumber::Rake::Task.new(:cukes) do |t|
  t.cucumber_opts = '--format pretty'
end

task :test => [:spec, :cukes]
task :default => :test
