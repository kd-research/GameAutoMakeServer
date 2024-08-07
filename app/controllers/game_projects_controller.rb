class GameProjectsController < ApplicationController
  before_action :authenticate_user!, only: %i[new create]
  before_action :validate_game_project_showable, only: %i[show webgl_build html_build]
  before_action :validate_game_project_owner, only: %i[edit update destroy send_message request_game_spec change_compile_type reset_conversation]

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
      response = GameGenerator::UnityClient.new.generate_game
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

  def html_build
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

  def change_compile_type
    @game_project.compile_type = params[:compile_type]
    @game_project.webgl_game_compile&.destroy
    @game_project.html_game_compile&.destroy

    if @game_project.save
      redirect_back(fallback_location: game_project_url(@game_project), notice: "Compile type was successfully changed.")
    else
      redirect_back(fallback_location: game_project_url(@game_project), alert: "Compile type was not changed.")
    end
  end

  def send_message
    to_send = params[:message]
    @game_project.chat_conversation =
      @game_project.chat_conversation.send_message(
        to_send,
        chat_system_message: @game_project.chat_agent_instruction,
      )
    @game_project.save!
    respond_to do |format|
      format.html { redirect_back(fallback_location: game_project_url(@game_project)) }
      format.js { render json: @game_project }
    end
  end

  def reset_conversation
    @game_project.chat_conversation = Conversation.new
    @game_project.save!
    redirect_back(fallback_location: game_project_url(@game_project), notice: "Conversation was successfully reset.")
  end

  def request_game_spec
    @game_project.game_generate_conversation =
      @game_project.chat_conversation.send_message(
        @game_project.summary_agent_task,
        chat_system_message: @game_project.summary_agent_instruction,
        role: "system"
      )
    @game_project.save!
    respond_to do |format|
      format.html { redirect_back(fallback_location: game_project_url(@game_project)) }
      format.js { render json: @game_project }
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

    return if @game_project.user == current_user

    respond_to do |format|
      format.html { redirect_back(fallback_location: game_project_url(@game_project), alert: "Only account owner can perform this action.") }
    end
  end

  # Only allow a list of trusted parameters through.
  def game_project_params
    params.require(:game_project).permit(:name, :description, :privacy, :chat_agent_instruction, :summary_agent_instruction, :summary_agent_task)
  end
end
