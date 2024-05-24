json.extract! webgl_game_compile, :id, :game_project_id, :data_file, :created_at, :updated_at
json.url webgl_game_compile_url(webgl_game_compile, format: :json)
json.data_file url_for(webgl_game_compile.data_file)
