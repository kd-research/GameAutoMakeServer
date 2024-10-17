require "application_system_test_case"

class PublishedGamesTest < ApplicationSystemTestCase
  setup do
    @published_game = published_games(:one)
  end

  test "visiting the index" do
    visit published_games_url

    assert_selector "h1", text: "Published games"
  end

  test "should create published game" do
    visit published_games_url
    click_on "New published game"

    fill_in "Name", with: @published_game.name
    click_on "Create Published game"

    assert_text "Published game was successfully created"
    click_on "Back"
  end

  test "should update Published game" do
    visit published_game_url(@published_game)
    click_on "Edit this published game", match: :first

    fill_in "Name", with: @published_game.name
    click_on "Update Published game"

    assert_text "Published game was successfully updated"
    click_on "Back"
  end

  test "should destroy Published game" do
    visit published_game_url(@published_game)
    click_on "Destroy this published game", match: :first

    assert_text "Published game was successfully destroyed"
  end
end
