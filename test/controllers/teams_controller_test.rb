require 'test_helper'

class TeamsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @team = teams(:one)
  end

  test "should get index" do
    get teams_url
    assert_response :success
  end

  test "should get show" do
    get team_url(@team)
    assert_response :success
  end

  test "should get new" do
    log_in_as @user
    get new_team_url
    assert_response :success
  end

end
