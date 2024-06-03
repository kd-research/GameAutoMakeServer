require "test_helper"

class GameCompilesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @game_compile = game_compiles(:one)
  end

  test "should get index" do
    get game_compiles_url

    assert_response :success
  end

  test "should get new" do
    get new_game_compile_url

    assert_response :success
  end

  test "should create game_compile" do
    assert_difference("GameCompile.count") do
      post game_compiles_url,
           params: { game_compile: { game_project_id: @game_compile.game_project_id,
                                     platform: @game_compile.platform } }
    end

    assert_redirected_to game_compile_url(GameCompile.last)
  end

  test "should show game_compile" do
    get game_compile_url(@game_compile)

    assert_response :success
  end

  test "should get edit" do
    get edit_game_compile_url(@game_compile)

    assert_response :success
  end

  test "should update game_compile" do
    patch game_compile_url(@game_compile),
          params: { game_compile: { game_project_id: @game_compile.game_project_id, platform: @game_compile.platform } }

    assert_redirected_to game_compile_url(@game_compile)
  end

  test "should destroy game_compile" do
    assert_difference("GameCompile.count", -1) do
      delete game_compile_url(@game_compile)
    end

    assert_redirected_to game_compiles_url
  end
end
