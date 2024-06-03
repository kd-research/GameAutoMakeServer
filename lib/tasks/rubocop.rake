require "rubocop/rake_task"

RuboCop::RakeTask.new do |task|
  task.requires << "rubocop-minitest"
  task.requires << "rubocop-performance"
  task.requires << "rubocop-rails"
end
