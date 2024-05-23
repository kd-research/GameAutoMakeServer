json.extract! game_compile, :id, :game_project_id, :platform, :package, :created_at, :updated_at
json.url game_compile_url(game_compile, format: :json)
json.package url_for(game_compile.package)
