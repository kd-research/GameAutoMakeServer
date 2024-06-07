class DevelopmentController < ApplicationController
  def reset_all
    system("rails db:fixtures:load", exception: true)
    system("rails db:seed", exception: true)
    redirect_to root_path, notice: "All data has been reset."
  rescue StandardError => e
    redirect_to root_path, alert: "Error: #{e.message}"
  end
end
