require "application_system_test_case"

class GameProjectsTest < ApplicationSystemTestCase
  setup do
    @game_project = game_projects(:one)
  end

  test "visiting the index" do
    visit game_projects_url

    assert_selector "h1", text: "Game projects"
  end

  test "should create game project" do
    visit game_projects_url
    click_on "New game project"

    fill_in "Description", with: @game_project.description
    fill_in "Name", with: @game_project.name
    fill_in "Privacy", with: @game_project.privacy
    click_on "Create Game project"

    assert_text "Game project was successfully created"
    click_on "Back"
  end

  test "should update Game project" do
    visit game_project_url(@game_project)
    click_on "Edit this game project", match: :first

    fill_in "Description", with: @game_project.description
    fill_in "Name", with: @game_project.name
    fill_in "Privacy", with: @game_project.privacy
    click_on "Update Game project"

    assert_text "Game project was successfully updated"
    click_on "Back"
  end

  test "should destroy Game project" do
    visit game_project_url(@game_project)
    click_on "Destroy this game project", match: :first

    assert_text "Game project was successfully destroyed"
  end
end
