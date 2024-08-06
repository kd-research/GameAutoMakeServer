class DialogController < ApplicationController
  before_action :game_project_dialog, only: %i[edit update]

  def edit; end

  def update
    if @dialog.update(dialog_params)
      redirect_to game_project_path(@game_project), notice: 'Message was successfully updated.'
    else
      render :edit
    end
  end

  private

  def game_project_dialog
    @game_project ||= GameProject.find(params[:game_project_id])
    @dialog = Dialog.find(params[:id])
  end

  def dialog_params
    params.require(:dialog).permit(:response_message)
  end
end
