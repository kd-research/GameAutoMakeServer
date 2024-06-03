require "test_helper"

class WebglGameCompilesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @webgl_game_compile = webgl_game_compiles(:one)
  end

  test "should get index" do
    get webgl_game_compiles_url

    assert_response :success
  end

  test "should get new" do
    get new_webgl_game_compile_url

    assert_response :success
  end

  test "should show webgl_game_compile" do
    get webgl_game_compile_url(@webgl_game_compile)

    assert_response :success
  end

  test "should destroy webgl_game_compile" do
    assert_difference("WebglGameCompile.count", -1) do
      delete webgl_game_compile_url(@webgl_game_compile)
    end

    assert_redirected_to webgl_game_compiles_url
  end
end
