class GameProjectsController < ApplicationController
  before_action :authenticate_user!, only: %i[new create]
  before_action :set_game_project, except: %i[index gallary new create]
  before_action :validate_game_project_showable, only: %i[show build build]
  before_action :validate_game_project_owner, only: %i[edit update destroy send_message request_game_spec change_compile_type reset_conversation]

  # GET /game_projects
  # Redirect to gallary page based on user sign in status
  # if user is signed in, show all projects (render gallary/all)
  # if user is not signed in, show only public projects (render gallary/public)
  def index
    @target_gallary_page = if user_signed_in?
                             game_projects_gallary_path(partial: "all")
                           else
                             game_projects_gallary_path(partial: "public")
                           end

    redirect_to @target_gallary_page if turbo_frame_request?
  end

  # GET /game_projects/gallary/:partial
  # The actual index page for game projects
  def gallary
    unless %w[all user public].include?(params[:partial])
      head :not_found and return
    end

    authenticate_user! unless params[:partial] == "public"

    if user_signed_in?
      @user_projects = current_user.game_projects
      @public_projects = GameProject.privacy_public.where.not(user: current_user)
    else
      @public_projects = GameProject.privacy_public
    end
  end

  # GET /game_projects/1
  def show
    if params[:style] == "card"
      render "show/card_view"
    end
  end

  # GET /game_projects/new
  def new
    @game_project = GameProject.new
  end

  # GET /game_projects/1/edit
  def edit; end

  # POST /game_projects/1/build
  def build
    return if @game_project.game_compile&.status_pending? || @game_project.game_compile&.status_compiling?

    @game_project.game_compile&.destroy!
    game_compile = @game_project.create_game_compile!(status: "pending")
    CompileJob.perform_later(game_compile.id)

    respond_to do |format|
      format.turbo_stream { head :ok }
      format.html { redirect_back(fallback_location: game_project_url(@game_project), notice: "Game build is on the way. You will be notified once it is ready.") }
    end
  end

  def rebuild
    @game_project.game_compile&.destroy!

    game_compile = @game_project.create_game_compile!(status: "pending")
    CompileJob.perform_later(game_compile.id)

    redirect_back(fallback_location: game_project_url(@game_project), notice: "Game build is on the way. You will be notified once it is ready.")
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
    @game_project.save!

    redirect_back(fallback_location: game_project_url(@game_project), notice: "Compile type was successfully changed.")
  end

  def send_message
    to_send = params[:message]
    Current.game_project.chat_conversation =
      Current.game_project.chat_conversation.send_message(
        to_send,
        chat_system_message: Current.game_project.chat_agent_instruction,
      )
    Current.game_project.save!

    respond_to do |format|
      format.turbo_stream do 
        render turbo_stream: turbo_stream.replace("chat", 
                                                  partial: Current.game_project.chat_conversation, 
                                                  locals: { allow_chat_action: send_message_game_project_path(Current.game_project) } )
      end
      format.html { render "game_projects_chat_and_conclude" }
    end
  end

  def reset_conversation
    @game_project.chat_conversation = Conversation.new
    @game_project.save!
    respond_to do |format|
      format.turbo_stream do 
        render turbo_stream: turbo_stream.replace("chat", 
                                                  partial: Current.game_project.chat_conversation, 
                                                  locals: { allow_chat_action: send_message_game_project_path(Current.game_project) } )
      end
      format.html { render "game_projects_chat_and_conclude" }
    end
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

  def chat_and_conclude
    render format: :turbo_stream
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_game_project
    @game_project = GameProject.find(params[:id])
    Current.game_project = @game_project
    Current.user = current_user if user_signed_in?
  end

  def validate_game_project_showable
    authenticate_user! if @game_project.privacy_private?

    head :not_found if @game_project.privacy_private? && @game_project.user != current_user
  end

  def validate_game_project_owner
    return if @game_project.user == current_user

    render status: :forbidden, plain: "Only account owner can perform this action." and return
  end

  # Only allow a list of trusted parameters through.
  def game_project_params
    params.require(:game_project).permit(:name, :description, :privacy, :compile_type, :chat_agent_instruction, :summary_agent_instruction, :summary_agent_task)
  end
end
