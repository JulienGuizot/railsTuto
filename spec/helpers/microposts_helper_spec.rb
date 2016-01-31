require 'spec_helper'

# Specs in this file have access to a helper object that includes
# the UsersHelper. For example:
#
# describe UsersHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       helper.concat_strings("this","that").should == "this that"
#     end
#   end
# end
describe UsersHelper do

  describe Micropost do

  before(:each) do
    @user = Factory(:user)
    @attr = {
        :content => "value for content",
        :user_id => 1
    }
  end

  it "should create new instance with valids contents" do
    @user.microposts.create!(@attr)
  end


  end

end

