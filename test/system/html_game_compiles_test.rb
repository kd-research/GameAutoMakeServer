require "application_system_test_case"

class HtmlGameCompilesTest < ApplicationSystemTestCase
  setup do
    @html_game_compile = html_game_compiles(:one)
  end

  test "visiting the index" do
    visit html_game_compiles_url

    assert_selector "h1", text: "Html game compiles"
  end

  test "should create html game compile" do
    visit html_game_compiles_url
    click_on "New html game compile"

    fill_in "Game project", with: @html_game_compile.game_project_id
    click_on "Create Html game compile"

    assert_text "Html game compile was successfully created"
    click_on "Back"
  end

  test "should update Html game compile" do
    visit html_game_compile_url(@html_game_compile)
    click_on "Edit this html game compile", match: :first

    fill_in "Game project", with: @html_game_compile.game_project_id
    click_on "Update Html game compile"

    assert_text "Html game compile was successfully updated"
    click_on "Back"
  end

  test "should destroy Html game compile" do
    visit html_game_compile_url(@html_game_compile)
    click_on "Destroy this html game compile", match: :first

    assert_text "Html game compile was successfully destroyed"
  end
end
