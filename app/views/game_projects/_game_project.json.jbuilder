json.extract! game_project, :id, :name, :description, :privacy, :created_at, :updated_at
json.url game_project_url(game_project, format: :json)
