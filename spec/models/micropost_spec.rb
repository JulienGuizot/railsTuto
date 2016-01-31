require 'spec_helper'

describe Micropost do

  before(:each) do
    @user = Factory(:user)
    @attr = { :content => "Message contents" }
  end

  it "should create instance micropost with good contents" do
    @user.microposts.create!(@attr)
  end

  describe "associating with the user" do

    before(:each) do
      @micropost = @user.microposts.create(@attr)
    end

    it "should have user field (id)" do
      @micropost.should respond_to(:user)
    end

    it "should have the good user associated" do
      @micropost.user_id.should == @user.id
      @micropost.user.should == @user
    end
  end

  describe "validations" do

    it "require user's id" do
      Micropost.new(@attr).should_not be_valid
    end

    it "require not empty content" do
      @user.microposts.build(:content => "  ").should_not be_valid
    end

    it "should refuse too long content (string)" do
      @user.microposts.build(:content => "a" * 141).should_not be_valid
    end
  end
end