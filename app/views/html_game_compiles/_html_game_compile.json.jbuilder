json.extract! html_game_compile, :id, :game_project_id, :html_file, :created_at, :updated_at
json.url html_game_compile_url(html_game_compile, format: :json)
json.html_file url_for(html_game_compile.html_file)
