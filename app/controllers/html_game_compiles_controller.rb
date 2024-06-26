class HtmlGameCompilesController < ApplicationController
  before_action :set_html_game_compile, only: %i[show destroy]

  # GET /html_game_compiles or /html_game_compiles.json
  def index
    unless Rails.env.development?
      redirect_to game_projects_path, notice: "This page is only available in development environment."
      return
    end

    @html_game_compiles = HtmlGameCompile.all
  end

  # GET /html_game_compiles/1 or /html_game_compiles/1.json
  def show; end

  # DELETE /html_game_compiles/1 or /html_game_compiles/1.json
  def destroy
    @html_game_compile.destroy!

    respond_to do |format|
      format.html { redirect_to root_path, notice: "Html game compile was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_html_game_compile
    @html_game_compile = HtmlGameCompile.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def html_game_compile_params
    params.require(:html_game_compile).permit(:game_project_id, :html_file)
  end
end
