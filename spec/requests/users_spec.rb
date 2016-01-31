require 'spec_helper'

describe "Users" do

  describe "sign up" do

    describe "echec" do

      it "should not create new user" do
        lambda do
        visit signup_path
        fill_in "nom",          :with => ""
        fill_in "email",        :with => ""
        fill_in "password",     :with => ""
        fill_in "Confirmation", :with => ""
        click_button
        response.should render_template('users/new')
        response.should have_selector("div#error_explanation")
        end.should_not change(User, :count)
      end
    end

    describe "success" do

      it "should create new user" do
        lambda do
          visit signup_path
          fill_in "nom", :with => "Example User"
          fill_in "email", :with => "user@example.com"
          fill_in "password", :with => "foobar"
          fill_in "Confirmation", :with => "foobar"
          click_button
          response.should have_selector("div.flash.success",
                                        :content => "Welcome to Example Application !")
          response.should render_template('users/show')
        end.should change(User, :count).by(1)
      end
    end
  end


  describe "sign in / sign out" do

    describe "echec" do
      it "should not sign in the user" do
        visit signin_path
        fill_in "email",    :with => ""
        fill_in "password", :with => ""
        click_button
        response.should have_selector("div.flash.error", :content => "invalid identification : email - password")
      end
    end

    describe "success" do
      it "should sign in the user, then sign out it" do
        user = Factory(:user)
        visit signin_path
        fill_in "email",    :with => user.email
        fill_in "password", :with => user.password
        click_button
        controller.should be_signed_in
        click_link "Sign out"
        controller.should_not be_signed_in
      end
    end
  end
end