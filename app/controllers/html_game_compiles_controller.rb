class HtmlGameCompilesController < ApplicationController
  before_action :set_game_project, except: %i[index]

  # GET /html_game_compiles or /html_game_compiles.json
  def index
    unless Rails.env.development?
      redirect_to game_projects_path, notice: "This page is only available in development environment."
      return
    end

    @html_game_compiles = HtmlGameCompile.all
  end

  def show
    respond_to do |format|
      format.turbo_stream
    end
  end

  def update
    @html_game_compile.update!(html_game_compile_params)
    redirect_to html_game_compile_path(@html_game_compile)
  end

  # DELETE /html_game_compiles/1 or /html_game_compiles/1.json
  def destroy
    game_project = @html_game_compile.game_compile.game_project
    @html_game_compile.destroy!

    redirect_to game_project, notice: "Html game compile was successfully destroyed."
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_game_project
    @html_game_compile = HtmlGameCompile.find(params[:id])
    Current.game_project = @html_game_compile.game_project
  end

  # Only allow a list of trusted parameters through.
  def html_game_compile_params
    params.require(:html_game_compile).permit(:game_project_id, :html_file)
  end
end
