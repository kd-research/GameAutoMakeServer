require "test_helper"

module Android
  class HotPatchGamesAuthenticatedControllerTest < ActionDispatch::IntegrationTest
    include Rails.application.routes.url_helpers
    include Devise::Test::IntegrationHelpers

    setup do
      # Set the host for URL helpers
      host! "example.com"
      @android_hot_patch_game = Android::HotPatchGame.first

      # Mock authentication
      # In a real test, you would sign in as an admin user here
      # This implementation depends on your authentication system
      user = users(:admin)
      sign_in(user)
    end

    test "should get all games index" do
      get android_hot_patch_games_url

      assert_response :success
      assert_equal 3, assigns(:android_hot_patch_games).size
    end

    test "should get new" do
      get new_android_hot_patch_game_url

      assert_response :success
    end

    test "should create android_hot_patch_game" do
      # Create a test file for upload
      icon_file = fixture_file_upload(Rails.root.join("test/fixtures/files/index.html"), "text/html")
      html_file = fixture_file_upload(Rails.root.join("test/fixtures/files/index.html"), "text/html")

      assert_difference("Android::HotPatchGame.count") do
        post android_hot_patch_games_url, params: {
          android_hot_patch_game: {
            name: "New Game",
            icon: icon_file,
            html: html_file
          }
        }
      end

      assert_redirected_to android_hot_patch_game_url(Android::HotPatchGame.last)
    end

    test "should get edit" do
      get edit_android_hot_patch_game_url(@android_hot_patch_game)

      assert_response :success
    end

    test "should update android_hot_patch_game" do
      patch android_hot_patch_game_url(@android_hot_patch_game), params: { android_hot_patch_game: { name: @android_hot_patch_game.name } }

      assert_redirected_to android_hot_patch_game_url(@android_hot_patch_game)
    end

    test "should destroy android_hot_patch_game" do
      assert_difference("Android::HotPatchGame.count", -1) do
        delete android_hot_patch_game_url(@android_hot_patch_game)
      end

      assert_redirected_to android_hot_patch_games_url
    end
  end
end
