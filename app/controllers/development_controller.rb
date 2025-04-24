class DevelopmentController < ApplicationController
  before_action :require_development_mode

  def reset_all
    system("rails db:fixtures:load", exception: true)
    system("rails db:seed", exception: true)
    redirect_to root_path, notice: "All data has been reset."
  rescue StandardError => e
    redirect_to root_path, alert: "Error: #{e.message}"
  end

  def developer_sign_in
    user = User.find_or_create_by!(email: "develop@me") do |u|
      u.password = "password"
      u.roles = "developer,admin"
    end

    sign_in(user)
    redirect_to root_path, notice: "You have been signed in."
  end

  private

  def require_development_mode
    raise "Not in development mode" unless Rails.env.development?
  end
end
