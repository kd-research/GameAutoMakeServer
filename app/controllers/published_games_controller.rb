class PublishedGamesController < ApplicationController
  before_action :set_published_game, only: %i[show edit update destroy]

  # GET /published_games or /published_games.json
  def index
    @published_games = PublishedGame.all
  end

  # GET /published_games/1 or /published_games/1.json
  def show; end

  # GET /published_games/new
  def new
    @published_game = PublishedGame.new
  end

  # GET /published_games/1/edit
  def edit; end

  # POST /published_games or /published_games.json
  def create
    @published_game = PublishedGame.new(published_game_params)

    respond_to do |format|
      if @published_game.save
        format.html { redirect_to published_game_url(@published_game), notice: "Published game was successfully created." }
        format.json { render :show, status: :created, location: @published_game }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @published_game.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /published_games/1 or /published_games/1.json
  def update
    respond_to do |format|
      if @published_game.update(published_game_params)
        format.html { redirect_to published_game_url(@published_game), notice: "Published game was successfully updated." }
        format.json { render :show, status: :ok, location: @published_game }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @published_game.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /published_games/1 or /published_games/1.json
  def destroy
    @published_game.destroy!

    respond_to do |format|
      format.html { redirect_to published_games_url, notice: "Published game was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_published_game
    @published_game = PublishedGame.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def published_game_params
    params.require(:published_game).permit(:name)
  end
end
