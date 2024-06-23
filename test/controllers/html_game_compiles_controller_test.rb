require "test_helper"

class HtmlGameCompilesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @html_game_compile = html_game_compiles(:one)
  end

  test "should get index" do
    get html_game_compiles_url

    assert_response :success
  end

  test "should get new" do
    get new_html_game_compile_url

    assert_response :success
  end

  test "should create html_game_compile" do
    assert_difference("HtmlGameCompile.count") do
      post html_game_compiles_url, params: { html_game_compile: { game_project_id: @html_game_compile.game_project_id } }
    end

    assert_redirected_to html_game_compile_url(HtmlGameCompile.last)
  end

  test "should show html_game_compile" do
    get html_game_compile_url(@html_game_compile)

    assert_response :success
  end

  test "should get edit" do
    get edit_html_game_compile_url(@html_game_compile)

    assert_response :success
  end

  test "should update html_game_compile" do
    patch html_game_compile_url(@html_game_compile), params: { html_game_compile: { game_project_id: @html_game_compile.game_project_id } }

    assert_redirected_to html_game_compile_url(@html_game_compile)
  end

  test "should destroy html_game_compile" do
    assert_difference("HtmlGameCompile.count", -1) do
      delete html_game_compile_url(@html_game_compile)
    end

    assert_redirected_to html_game_compiles_url
  end
end
