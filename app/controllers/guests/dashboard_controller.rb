module Guests
  class DashboardController < ApplicationController
    before_action -> { redirect_to users_dashboard_index_path if user_signed_in? }

    def index; end
  end
end
