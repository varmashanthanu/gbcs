require 'test_helper'

class MembersControllerTest < ActionDispatch::IntegrationTest
  test "should get invite" do
    get members_invite_url
    assert_response :success
  end

  test "should get join" do
    get members_join_url
    assert_response :success
  end

  test "should get reject" do
    get members_reject_url
    assert_response :success
  end

  test "should get leave" do
    get members_leave_url
    assert_response :success
  end

end
