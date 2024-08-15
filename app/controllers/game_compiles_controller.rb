class GameCompilesController < ApplicationController
  before_action :set_game_compile, only: %i[show destroy download_compile_log]
  # GET /game_compiles or /game_compiles.json
  def index
    @game_compiles = GameCompile.all
  end

  # GET /game_compiles/1 
  # For compiling log
  def show; end

  def download_compile_log
    send_data @game_compile.compile_log, filename: 'compile_log.txt'
  end

  def destroy
    @game_compile = GameCompile.find(params[:id])
    @game_compile.destroy
    redirect_back(fallback_location: root_path)
  end

  private

  def set_game_compile
    @game_compile = GameCompile.find(params[:id])
  end
end
