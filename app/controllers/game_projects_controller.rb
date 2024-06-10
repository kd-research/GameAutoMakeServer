class GameProjectsController < ApplicationController
  before_action :authenticate_user!, only: %i[new create]
  before_action :validate_game_project_showable, only: %i[show webgl_build]
  before_action :validate_game_project_owner, only: %i[edit update destroy]

  # GET /game_projects or /game_projects.json
  def index
    if user_signed_in?
      @user_projects = current_user.game_projects
      @public_projects = GameProject.privacy_public.where.not(user: current_user)
    else
      @public_projects = GameProject.privacy_public
    end
  end

  # GET /game_projects/1 or /game_projects/1.json
  def show; end

  # GET /game_projects/new
  def new
    @game_project = GameProject.new
  end

  # GET /game_projects/1/edit
  def edit; end

  # POST /game_projects/1/webgl_build
  def webgl_build
    begin
      response = GameGenerator::Client.new.generate_game
    rescue GRPC::Unavailable
      respond_to do |format|
        format.html { redirect_to game_project_url(@game_project), alert: "Oops.. Game generator is down. Please come back later." }
      end
      return
    end

    sample = WebglGameCompile.new_from_bytes(
      loader: response.loader.data,
      data: response.data.data,
      framework: response.framework.data,
      code: response.code.data
    )

    sample.game_project = @game_project

    respond_to do |format|
      if sample.save
        format.html { redirect_to game_project_url(@game_project), notice: "WebGL build was successfully created." }
      else
        format.html { redirect_to game_project_url(@game_project), alert: "WebGL build was not created." }
      end
    end
  end

  # POST /game_projects or /game_projects.json
  def create
    @game_project = GameProject.new(game_project_params)
    @game_project.user = current_user

    respond_to do |format|
      if @game_project.save
        format.html { redirect_to game_project_url(@game_project), notice: "Game project was successfully created." }
        format.json { render :show, status: :created, location: @game_project }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @game_project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /game_projects/1 or /game_projects/1.json
  def update
    respond_to do |format|
      if @game_project.update(game_project_params)
        format.html { redirect_to game_project_url(@game_project), notice: "Game project was successfully updated." }
        format.json { render :show, status: :ok, location: @game_project }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @game_project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /game_projects/1 or /game_projects/1.json
  def destroy
    @game_project.destroy!

    respond_to do |format|
      format.html { redirect_to game_projects_url, notice: "Game project was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_game_project
    @game_project = GameProject.find(params[:id])
  end

  def validate_game_project_showable
    set_game_project
    authenticate_user! if @game_project.privacy_private?

    head :not_found if @game_project.privacy_private? && @game_project.user != current_user
  end

  def validate_game_project_owner
    set_game_project

    head :unauthorized unless @game_project.user == current_user
  end

  # Only allow a list of trusted parameters through.
  def game_project_params
    params.require(:game_project).permit(:name, :description, :privacy)
  end
end
