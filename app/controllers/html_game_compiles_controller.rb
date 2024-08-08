class HtmlGameCompilesController < ApplicationController
  before_action :set_game_project, only: %i[build]
  before_action :set_html_game_compile, only: %i[show destroy update]

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

  def update
    @html_game_compile.update!(html_game_compile_params)
    redirect_to html_game_compile_path(@html_game_compile)
  end

  # DELETE /html_game_compiles/1 or /html_game_compiles/1.json
  def destroy
    @html_game_compile.destroy!

    respond_to do |format|
      format.html { redirect_to root_path, notice: "Html game compile was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def build
    begin
      unless @game_project.game_generate_conversation.present?
        format.html { redirect_back(fallback_location: game_project_url(@game_project), alert: "'Conclude Chat' is required to build the game.") }
        return
      end

      generated_description = @game_project.game_generate_conversation.dialog.response_message
      response = GameGenerator::CrewClient.new.generate_html_game(name: @game_project.name, description: generated_description)
    rescue GRPC::Unavailable
      respond_to do |format|
        format.html { redirect_to game_project_url(@game_project), alert: "Oops.. Game generator is down. Please come back later." }
      end
      return
    rescue GRPC::Unknown
      respond_to do |format|
        format.html { redirect_to game_project_url(@game_project), alert: "Oops.. Generated game is not playable. Please try it again." }
      end
      return
    end

    sample = HtmlGameCompile.new_from_bytes(response.html.data)
    sample.game_project = @game_project

    respond_to do |format|
      if sample.save
        format.html { redirect_to game_project_url(@game_project), notice: "HTML build was successfully created." }
      else
        format.html { redirect_to game_project_url(@game_project), alert: "HTML build was not created." }
      end
    end
  end


  private

  # Use callbacks to share common setup or constraints between actions.
  def set_html_game_compile
    @html_game_compile = HtmlGameCompile.find(params[:id])
  end

  def set_game_project
    @game_project = GameProject.find(params[:game_project_id])
  end

  # Only allow a list of trusted parameters through.
  def html_game_compile_params
    params.require(:html_game_compile).permit(:game_project_id, :html_file)
  end
end
