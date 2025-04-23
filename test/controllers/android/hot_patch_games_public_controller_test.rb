require "test_helper"

module Android
  class HotPatchGamesPublicControllerTest < ActionDispatch::IntegrationTest
    include Rails.application.routes.url_helpers

    setup do
      # Set the host for URL helpers
      host! "example.com"
      @android_hot_patch_game = Android::HotPatchGame.first
    end

    test "should get urls correctly" do
      game_object = Android::HotPatchGame.first
      icon_url = url_for(game_object.icon)
      html_url = url_for(game_object.html)

      get icon_url

      assert_response :found

      get html_url

      assert_response :found
    end

    test "should get public index only" do
      get android_hot_patch_games_url

      assert_response :success
      assert_equal 2, assigns(:android_hot_patch_games).size
    end

    test "should show android_hot_patch_game" do
      get android_hot_patch_game_url(@android_hot_patch_game)

      assert_response :success
    end
  end
end
