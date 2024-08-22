class GameCompilesController < ApplicationController
  before_action :set_game_compile, only: %i[show_compile_log destroy download_compile_log]

  # GET /game_compiles/1 
  # For compiling log
  def show_compile_log; end

  def download_compile_log
    send_data Current.game_compile.compile_log, filename: 'compile_log.txt'
  end

  def destroy
    Current.game_compile.destroy
    redirect_back(fallback_location: root_path)
  end

  private

  def set_game_compile
    Current.game_project = GameProject.find(params[:id])
    Current.has_game_compile!
  end
end
