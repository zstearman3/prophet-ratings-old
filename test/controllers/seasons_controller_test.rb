require 'test_helper'

class SeasonsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:one)
    @other_user = users(:two)
  end
  
  test "should get new" do
    log_in_as @user
    get seasons_new_url
    assert_response :success
  end
  
  test "requires admin to get new" do
    log_in_as @other_user
    get seasons_new_url
    assert_redirected_to root_url
    assert_not flash.empty?
  end

end
