require "test_helper"

class GameProjectsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @game_project = game_projects(:default)
  end

  test "should get index" do
    get game_projects_url
    assert_response :success
  end

  test "should get new" do
    get new_game_project_url
    assert_response :success
  end

  test "should create game_project" do
    assert_difference("GameProject.count") do
      post game_projects_url, params: { game_project: { description: @game_project.description, name: @game_project.name, privacy: @game_project.privacy } }
    end

    assert_redirected_to game_project_url(GameProject.last)
  end

  test "should show game_project" do
    get game_project_url(@game_project)
    assert_response :success
  end

  test "should get edit" do
    get edit_game_project_url(@game_project)
    assert_response :success
  end

  test "should update game_project" do
    patch game_project_url(@game_project), params: { game_project: { description: @game_project.description, name: @game_project.name, privacy: @game_project.privacy } }
    assert_redirected_to game_project_url(@game_project)
  end

  test "should destroy game_project" do
    assert_difference("GameProject.count", -1) do
      delete game_project_url(@game_project)
    end

    assert_redirected_to game_projects_url
  end
end
