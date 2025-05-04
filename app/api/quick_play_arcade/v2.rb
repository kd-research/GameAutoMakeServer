module QuickPlayArcade
  class V2 < Grape::API
    version %w[v2], using: :path
    format :json

    desc "It will receive game assets and a natural language request to
    modify this game (ui, playing mechanism etc), and it will return a new html
    game that will fulfill this requirement."
    params do
      requires :game_icon, type: File
      requires :game_splash, type: File
      requires :game_bundle, type: File
      requires :request, type: String
    end
    post "/customize_game" do
      binding.pry
      raise NotImplementedError, "This endpoint is not implemented yet"
    end
  end
end
