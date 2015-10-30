exec('bundle', 'exec', $PROGRAM_NAME, *ARGV) unless ENV['BUNDLE_GEMFILE']

require 'bundler/gem_tasks'
require 'rubocop/rake_task'
require 'rspec/core/rake_task'

task default: [:spec, :rubocop]

task spec: [:'spec:unit', :'spec:integration']

def rspec_options(task)
  # output xml if we are running through jenkins
  return unless ENV['JENKINS_HOME']
  opts = [
    '--format RspecJunitFormatter',
    "--out reports/#{task.name}.xml ",
    '--format documentation'
  ]
  task.rspec_opts = opts.join(' ')
end

namespace :spec do
  ENV['COVERAGE'] = 'yes'

  desc 'run unit tests'
  RSpec::Core::RakeTask.new(:unit) do |task|
    rspec_options(task)
    task.pattern = 'spec/unit/**/*_spec.rb'
  end

  desc 'run integration tests'
  RSpec::Core::RakeTask.new(:integration) do |task|
    rspec_options(task)
    task.pattern = 'spec/integration/**/*_spec.rb'
  end
end

RuboCop::RakeTask.new
