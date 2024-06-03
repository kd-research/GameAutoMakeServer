class GameCompilesController < ApplicationController
  before_action :set_game_compile, only: %i[show edit update destroy]

  # GET /game_compiles or /game_compiles.json
  def index
    @game_compiles = GameCompile.all
  end

  # GET /game_compiles/1 or /game_compiles/1.json
  def show; end

  # GET /game_compiles/new
  def new
    @game_compile = GameCompile.new
  end

  # GET /game_compiles/1/edit
  def edit; end

  # POST /game_compiles or /game_compiles.json
  def create
    @game_compile = GameCompile.new(game_compile_params)

    respond_to do |format|
      if @game_compile.save
        format.html { redirect_to game_compile_url(@game_compile), notice: "Game compile was successfully created." }
        format.json { render :show, status: :created, location: @game_compile }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @game_compile.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /game_compiles/1 or /game_compiles/1.json
  def update
    respond_to do |format|
      if @game_compile.update(game_compile_params)
        format.html { redirect_to game_compile_url(@game_compile), notice: "Game compile was successfully updated." }
        format.json { render :show, status: :ok, location: @game_compile }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @game_compile.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /game_compiles/1 or /game_compiles/1.json
  def destroy
    @game_compile.destroy!

    respond_to do |format|
      format.html { redirect_to game_compiles_url, notice: "Game compile was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_game_compile
    @game_compile = GameCompile.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def game_compile_params
    params.require(:game_compile).permit(:game_project_id, :platform, :package)
  end
end
