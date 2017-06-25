require 'test_helper'

class InvitesControllerTest < ActionDispatch::IntegrationTest
  test "should get send" do
    get invites_send_url
    assert_response :success
  end

  test "should get reject" do
    get invites_reject_url
    assert_response :success
  end

end
