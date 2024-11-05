require "test_helper"

module Android
  class HotPatchGamesControllerTest < ActionDispatch::IntegrationTest
    setup do
      @android_hot_patch_game = android_hot_patch_games(:one)
    end

    test "should get index" do
      get android_hot_patch_games_url

      assert_response :success
    end

    test "should get new" do
      get new_android_hot_patch_game_url

      assert_response :success
    end

    test "should create android_hot_patch_game" do
      assert_difference("Android::HotPatchGame.count") do
        post android_hot_patch_games_url, params: { android_hot_patch_game: { name: @android_hot_patch_game.name } }
      end

      assert_redirected_to android_hot_patch_game_url(Android::HotPatchGame.last)
    end

    test "should show android_hot_patch_game" do
      get android_hot_patch_game_url(@android_hot_patch_game)

      assert_response :success
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
