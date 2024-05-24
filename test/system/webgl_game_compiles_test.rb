require "application_system_test_case"

class WebglGameCompilesTest < ApplicationSystemTestCase
  setup do
    @webgl_game_compile = webgl_game_compiles(:one)
  end

  test "visiting the index" do
    visit webgl_game_compiles_url
    assert_selector "h1", text: "Webgl game compiles"
  end

  test "should create webgl game compile" do
    visit webgl_game_compiles_url
    click_on "New webgl game compile"

    fill_in "Game project", with: @webgl_game_compile.game_project_id
    click_on "Create Webgl game compile"

    assert_text "Webgl game compile was successfully created"
    click_on "Back"
  end

  test "should update Webgl game compile" do
    visit webgl_game_compile_url(@webgl_game_compile)
    click_on "Edit this webgl game compile", match: :first

    fill_in "Game project", with: @webgl_game_compile.game_project_id
    click_on "Update Webgl game compile"

    assert_text "Webgl game compile was successfully updated"
    click_on "Back"
  end

  test "should destroy Webgl game compile" do
    visit webgl_game_compile_url(@webgl_game_compile)
    click_on "Destroy this webgl game compile", match: :first

    assert_text "Webgl game compile was successfully destroyed"
  end
end
