require 'test_helper'

class StadiaControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get Stadia_new_url
    assert_response :success
  end

end
