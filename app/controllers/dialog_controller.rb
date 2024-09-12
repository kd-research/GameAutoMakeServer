class DialogController < ApplicationController
  before_action :authenticate_user!
  before_action :game_project_dialog
  before_action :validate_game_project_owner

  def edit; end

  def update
    if @dialog.update(dialog_params)
      redirect_to game_project_path(Current.game_project), notice: "Message was successfully updated."
    else
      render :edit
    end
  end

  private

  def game_project_dialog
    Current.game_project = GameProject.find(params[:game_project_id])
    Current.user = current_user if user_signed_in?
    @dialog = Dialog.find(params[:id])
  end

  def validate_game_project_owner
    return if Current.user_can_manage_game_project?

    render status: :forbidden, plain: "Only account owner can perform this action." and return
  end

  def dialog_params
    params.require(:dialog).permit(:response_message)
  end
end
