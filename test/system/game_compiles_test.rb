require "application_system_test_case"

class GameCompilesTest < ApplicationSystemTestCase
  setup do
    @game_compile = game_compiles(:one)
  end

  test "visiting the index" do
    visit game_compiles_url
    assert_selector "h1", text: "Game compiles"
  end

  test "should create game compile" do
    visit game_compiles_url
    click_on "New game compile"

    fill_in "Game project", with: @game_compile.game_project_id
    fill_in "Platform", with: @game_compile.platform
    click_on "Create Game compile"

    assert_text "Game compile was successfully created"
    click_on "Back"
  end

  test "should update Game compile" do
    visit game_compile_url(@game_compile)
    click_on "Edit this game compile", match: :first

    fill_in "Game project", with: @game_compile.game_project_id
    fill_in "Platform", with: @game_compile.platform
    click_on "Update Game compile"

    assert_text "Game compile was successfully updated"
    click_on "Back"
  end

  test "should destroy Game compile" do
    visit game_compile_url(@game_compile)
    click_on "Destroy this game compile", match: :first

    assert_text "Game compile was successfully destroyed"
  end
end
