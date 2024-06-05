module Users
  class DashboardController < ApplicationController
    before_action :authenticate_user!

    layout "application"

    def index; end
  end
end
