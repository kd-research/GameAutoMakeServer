module Android
  class ServiceTestController < ApplicationController
    def index; end

    def customize_game
      params = self.params.permit(:game_file, :request, :system_prompt, :model).deep_dup
      params[:game_html] = params[:game_file].read
      response = CustomizeGameService.customize_game(params)
      render json: { response: response }
    end
  end
end
