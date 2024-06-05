require "test_helper"

module Guests
  class DashboardControllerTest < ActionDispatch::IntegrationTest
    test "should get index" do
      get guests_dashboard_index_url

      assert_response :success
    end
  end
end
