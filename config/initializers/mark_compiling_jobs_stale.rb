Rails.application.config.after_initialize do
  begin
  unless defined?(Rails::Console) || File.split($0).last == "rake"
    GameCompile.status_compiling.update_all(status: "stale")
    GameCompile.status_pending.update_all(status: "stale")
  end
  rescue
  end
end
