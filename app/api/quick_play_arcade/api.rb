module QuickPlayArcade
  class API < Grape::API
    version "v1", using: :path
    format :json

    desc "Register a new android device (installed app) and get a token for the device"
    get "/register_device" do
      device = ClientTerminal.create!
      { device_token: device.token }
    end

    desc "Get the top 10 scores for a game"
    params do
      requires :game_id, type: Integer
    end
    get "/top_scores/:game_id" do
      game = PublishedGame.find_or_create_by!(id: params[:game_id])
      scores = game.scores.order(value: :desc).limit(10)
      amount = game.scores.count

      scores = scores.map do |score|
        { score: score.value }
      end
      { total_participate: amount, top_10: scores }
    end

    resource :device do
      desc "Upload a new score for a game"
      params do
        requires :device_token, type: String
        requires :game_id, type: Integer
        requires :score, type: Integer
      end
      post "/upload_score" do
        device = ClientTerminal.find_by_token(params[:device_token])  # rubocop:disable Rails/DynamicFindBy
        game = PublishedGame.find_or_create_by!(id: params[:game_id])

        score = ScoreBoard::Score.create!(client_terminal: device, published_game: game, value: params[:score])
        body false
      end

      desc "Get personal scores for a game"
      params do
        requires :device_token, type: String
        requires :game_id, type: Integer
        optional :limit, type: Integer, default: 3
      end
      post "/scores" do
        device = ClientTerminal.find_by_token(params[:device_token])  # rubocop:disable Rails/DynamicFindBy
        game = PublishedGame.find_or_create_by!(id: params[:game_id])
        total_score_size = ScoreBoard::Score.where(published_game: game).count
        ScoreBoard::Score.ranked_device_game_score(device, game, limit: params[:limit]).map do |score|
          { score: score.value, rank: score.rank, percentage: (1 - (score.rank.to_f / total_score_size.to_f)) * 100 }
        end
      end
    end

    desc "It will receive a game html source file, and a natural language request to
    modify this game (ui, playing machenism etc), and it will return a new html
    game that will fulfill this requirement."
    params do
      requires :game_html, type: String
      requires :request, type: String
      optional :system_prompt, type: String, default: "Follow the request and modify the given game html"
      optional :model, type: String
    end
    post "/customize_game" do
      CustomizeGameService.customize_game(params).fetch(:parsed)
    end
  end
end
