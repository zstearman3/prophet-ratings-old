require 'test_helper'

class StadiumTest < ActiveSupport::TestCase
  def setup
    @stadium = stadia(:one)
  end
  
  test 'should be valid' do
    assert @stadium.valid?
  end
  
  test 'should require name' do
    @stadium.name = "     "
    assert_not @stadium.valid?
  end
end
