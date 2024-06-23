class WebglGameCompilesController < ApplicationController
  before_action :set_webgl_game_compile, only: %i[show destroy]

  # GET /webgl_game_compiles or /webgl_game_compiles.json
  def index
    unless Rails.env.development?
      redirect_to game_projects_url, notice: "This feature is only available in development environment."
      return
    end

    @webgl_game_compiles = WebglGameCompile.all
  end

  # GET /webgl_game_compiles/1 or /webgl_game_compiles/1.json
  def show; end

  # DELETE /webgl_game_compiles/1 or /webgl_game_compiles/1.json
  def destroy
    @webgl_game_compile.destroy!

    respond_to do |format|
      format.html { redirect_to root_path, notice: "Webgl game compile was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_webgl_game_compile
    @webgl_game_compile = WebglGameCompile.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def webgl_game_compile_params
    params.require(:webgl_game_compile).permit(:game_project_id, :data_file)
  end
end
