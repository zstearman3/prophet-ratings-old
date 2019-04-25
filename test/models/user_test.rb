require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(first_name: 'Example', last_name: 'User', email: 'example@user.com',
                     password: 'Password', password_confirmation: 'Password')
    @user2 = users(:two)
  end
  
  test "should be valid" do 
    assert @user.valid?
  end
  
  test "email should be present" do
    @user.email = "     "
    assert_not @user.valid?
  end
  
  test "email should be unique" do
    @user.email = @user2.email
    assert_not @user.valid?
  end 
  
  test "should require valid email address" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end
  
  test "name should be present" do
    @user.last_name = "     "
    assert_not @user.valid?
  end
  
  test "password should be present (nonblank)" do
    @user.password = @user.password_confirmation = " " * 6
    assert_not @user.valid?
  end
  
  test "password should have a minimum length" do
    @user.password = @user.password_confirmation = " " * 5
    assert_not @user.valid?
  end
  
  test "authenticated? should return false for a user with nil digest" do
    assert_not @user.authenticated?(:remember, '')
  end
end
