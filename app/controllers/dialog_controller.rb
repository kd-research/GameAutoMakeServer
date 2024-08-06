class DialogController < ApplicationController
  before_action :find_dialog, only: [:edit, :update]

  def edit; end

  def update
    if @dialog.update(dialog_params)
      redirect_to root_path
    else
      render :edit
    end
  end

  private

  def find_dialog
    @dialog = Dialog.find(params[:id])
  end

  def dialog_params
    params.require(:dialog).permit(:response_message)
  end
end
