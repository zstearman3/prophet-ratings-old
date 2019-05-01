require 'test_helper'

class StadiaControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:one)
  end
  
  test "should get new" do
    log_in_as @user
    get stadia_new_url
    assert_response :success
  end

end
