task :dev do
  chdir Rails.root do
    Kernel.exec 'bundle exec ./bin/dev'
  end
end
