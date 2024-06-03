require "test_helper"

class UnityStorageDiskControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get unity_storage_disk_show_url

    assert_response :success
  end
end
