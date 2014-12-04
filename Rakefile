begin
  require 'rspec/core/rake_task'
  namespace :spec do
    desc 'Run unit specs'
    RSpec::Core::RakeTask.new(:units) do |t|
      t.pattern = 'spec/**/*_spec.rb'
    end
  end

  desc 'Alias for spec:units (default task)'
  task spec: :'spec:units'
  task test: :spec
  task default: :spec
rescue LoadError
  nil
end
