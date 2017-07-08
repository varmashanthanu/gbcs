require 'test_helper'

class AdminControllerTest < ActionDispatch::IntegrationTest
  test "should get make_admin" do
    get admin_make_admin_url
    assert_response :success
  end

end
