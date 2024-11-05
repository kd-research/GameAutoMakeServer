require "application_system_test_case"

module Android
  class HotPatchGamesTest < ApplicationSystemTestCase
    setup do
      @android_hot_patch_game = android_hot_patch_games(:one)
    end

    test "visiting the index" do
      visit android_hot_patch_games_url

      assert_selector "h1", text: "Hot patch games"
    end

    test "should create hot patch game" do
      visit android_hot_patch_games_url
      click_on "New hot patch game"

      fill_in "Name", with: @android_hot_patch_game.name
      click_on "Create Hot patch game"

      assert_text "Hot patch game was successfully created"
      click_on "Back"
    end

    test "should update Hot patch game" do
      visit android_hot_patch_game_url(@android_hot_patch_game)
      click_on "Edit this hot patch game", match: :first

      fill_in "Name", with: @android_hot_patch_game.name
      click_on "Update Hot patch game"

      assert_text "Hot patch game was successfully updated"
      click_on "Back"
    end

    test "should destroy Hot patch game" do
      visit android_hot_patch_game_url(@android_hot_patch_game)
      click_on "Destroy this hot patch game", match: :first

      assert_text "Hot patch game was successfully destroyed"
    end
  end
end
