require 'test_helper'

class UserSkillsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get user_skills_index_url
    assert_response :success
  end

  test "should get fffnew" do
    get user_skills_new_url
    assert_response :success
  end

  test "should get create" do
    get user_skills_create_url
    assert_response :success
  end

  test "should get edit" do
    get user_skills_edit_url
    assert_response :success
  end

  test "should get update" do
    get user_skills_update_url
    assert_response :success
  end

  test "should get destroy" do
    get user_skills_destroy_url
    assert_response :success
  end

end
