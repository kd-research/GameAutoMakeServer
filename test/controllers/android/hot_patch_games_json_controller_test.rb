require "test_helper"

module Android
  class HotPatchGamesJsonControllerTest < ActionDispatch::IntegrationTest
    include Rails.application.routes.url_helpers

    setup do
      # Set the host for URL helpers
      host! "example.com"
      @android_hot_patch_game = Android::HotPatchGame.first
    end

    test "should get index json" do
      get android_hot_patch_games_url, as: :json

      # Since we've stubbed the rendering, just assert that the request was successful
      assert_response :success
      json_response = response.parsed_body

      assert_kind_of Array, json_response
      assert_equal 2, json_response.size
      assert_includes json_response.first.keys, "name"
      assert_includes json_response.first.keys, "url"
    end
  end
end
