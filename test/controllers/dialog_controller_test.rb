require "test_helper"

class DialogControllerTest < ActionDispatch::IntegrationTest
  test "should get edit" do
    get dialog_edit_url

    assert_response :success
  end

  test "should get update" do
    get dialog_update_url

    assert_response :success
  end
end
