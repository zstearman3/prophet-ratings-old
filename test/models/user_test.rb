require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(first_name: "Zach", email: "z.stearman@lpsus.net")
  end
  
  test "should be valid" do 
    assert @user.valid?
  end
end
