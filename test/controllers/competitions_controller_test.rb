require 'test_helper'

class CompetitionsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get competitions_index_url
    assert_response :success
  end

  test "should get show" do
    get competitions_show_url
    assert_response :success
  end

  test "should get new" do
    get competitions_new_url
    assert_response :success
  end

  test "should get create" do
    get competitions_create_url
    assert_response :success
  end

  test "should get edit" do
    get competitions_edit_url
    assert_response :success
  end

  test "should get update" do
    get competitions_update_url
    assert_response :success
  end

  test "should get destroy" do
    get competitions_destroy_url
    assert_response :success
  end

end
