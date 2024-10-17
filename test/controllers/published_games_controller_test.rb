require "test_helper"

class PublishedGamesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @published_game = published_games(:one)
  end

  test "should get index" do
    get published_games_url

    assert_response :success
  end

  test "should get new" do
    get new_published_game_url

    assert_response :success
  end

  test "should create published_game" do
    assert_difference("PublishedGame.count") do
      post published_games_url, params: { published_game: { name: @published_game.name } }
    end

    assert_redirected_to published_game_url(PublishedGame.last)
  end

  test "should show published_game" do
    get published_game_url(@published_game)

    assert_response :success
  end

  test "should get edit" do
    get edit_published_game_url(@published_game)

    assert_response :success
  end

  test "should update published_game" do
    patch published_game_url(@published_game), params: { published_game: { name: @published_game.name } }

    assert_redirected_to published_game_url(@published_game)
  end

  test "should destroy published_game" do
    assert_difference("PublishedGame.count", -1) do
      delete published_game_url(@published_game)
    end

    assert_redirected_to published_games_url
  end
end
