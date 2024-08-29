Rails.application.config.after_initialize do
  unless defined?(Rails::Console) || File.split($0).last == 'rake'
    GameCompile.status_compiling.update_all(status: 'stale')
  end
end
