require 'spec_helper'

describe User do

  before(:each) do
    @attr = {
        :nom => "Example User",
        :email => "user@example.com",
        :password => "foobar",
        :password_confirmation => "foobar"
    }
  end

  it "should create new instance with valid contents" do
    User.create!(@attr)
  end

  it "exige un nom" do
    no_nom_user = User.new(@attr.merge(:nom => ""))
    no_nom_user.should_not be_valid
  end

  it "devrait rejeter les noms trop longs" do
    long_nom = "a" * 51
    long_nom_user = User.new(@attr.merge(:nom => long_nom))
    long_nom_user.should_not be_valid
  end

  it "exige une adresse email" do
    no_email_user = User.new(@attr.merge(:email => ""))
    no_email_user.should_not be_valid
  end

  it "devrait accepter une adresse email valide" do
    adresses = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp]
    adresses.each do |address|
      valid_email_user = User.new(@attr.merge(:email => address))
      valid_email_user.should be_valid
    end
  end

  it "devrait rejeter une adresse email invalide" do
    adresses = %w[user@foo,com user_at_foo.org example.user@foo.]
    adresses.each do |address|
      invalid_email_user = User.new(@attr.merge(:email => address))
      invalid_email_user.should_not be_valid
    end
  end

  it "should be eject an invalid email" do
    upcased_email = @attr[:email].upcase
    User.create!(@attr.merge(:email => upcased_email))
    user_with_duplicate_email = User.new(@attr)
    user_with_duplicate_email.should_not be_valid
  end

  it "devrait rejeter un email double" do
    # Place un utilisateur avec un email donné dans la BD.
    User.create!(@attr)
    user_with_duplicate_email = User.new(@attr)
    user_with_duplicate_email.should_not be_valid
  end

  describe "password validations" do

    it "devrait exiger un mot de passe" do
      User.new(@attr.merge(:password => "", :password_confirmation => "")).
          should_not be_valid
    end

    it "devrait exiger une confirmation du mot de passe qui correspond" do
      User.new(@attr.merge(:password_confirmation => "invalid")).
          should_not be_valid
    end

    it "devrait rejeter les mots de passe (trop) courts" do
      short = "a" * 5
      hash = @attr.merge(:password => short, :password_confirmation => short)
      User.new(hash).should_not be_valid
    end

    it "devrait rejeter les (trop) longs mots de passe" do
      long = "a" * 41
      hash = @attr.merge(:password => long, :password_confirmation => long)
      User.new(hash).should_not be_valid
    end
  end



  describe "password encryption" do

    before(:each) do
      @user = User.create!(@attr)
    end

    it "should have a encrypted password content" do
      @user.should respond_to(:encrypted_password)
    end

    it "should define encrypted password" do
      @user.encrypted_password.should_not be_blank
    end




    describe "Method has_password?" do

      it "return true if passwords are equals" do
        @user.has_password?(@attr[:password]).should be_true
      end

      it "return false if password are differents" do
        @user.has_password?("invalide").should be_false
      end
    end



    describe "authenticate method" do

      it "should return nil if email/password in inequation" do
        wrong_password_user = User.authenticate(@attr[:email], "wrongpass")
        wrong_password_user.should be_nil
      end

      it "should return nil when email is not exist in user database" do
        nonexistent_user = User.authenticate("bar@foo.com", @attr[:password])
        nonexistent_user.should be_nil
      end

      it "should return user if email/password correspond" do
        matching_user = User.authenticate(@attr[:email], @attr[:password])
        matching_user.should == @user
      end
    end

  end

  describe "Admin field" do

    before(:each) do
      @user = User.create!(@attr)
    end

    it "should confirm existing 'admin' field" do
      @user.should respond_to(:admin)
    end

    it "should not be an admin by default" do
      @user.should_not be_admin
    end

    it "could become an admin" do
      @user.toggle!(:admin)
      @user.should be_admin
    end
  end

  describe "associations with microposts" do

    before(:each) do
      @user = User.create(@attr)
    end

    it "should have 'microposts' content" do
      @user.should respond_to(:microposts)
    end
  end

  describe "micropost associations" do

    before(:each) do
      @user = User.create(@attr)
      @mp1 = Factory(:micropost, :user => @user, :created_at => 1.day.ago)
      @mp2 = Factory(:micropost, :user => @user, :created_at => 1.hour.ago)
    end

    it "should have 'microposts' content" do
      @user.should respond_to(:microposts)
    end

    it "should have good miscroposts in the correct order (date)" do
      @user.microposts.should == [@mp2, @mp1]
    end

    it "should destroy associated microposts" do
      @user.destroy
      [@mp1, @mp2].each do |micropost|
        Micropost.find_by_id(micropost.id).should be_nil
      end
    end

    describe "Alimentation state" do

      it "should have 'feed' method" do
        @user.should respond_to(:feed)
      end

      it "should include user's microposts" do
        @user.feed.include?(@mp1).should be_true
        @user.feed.include?(@mp2).should be_true
      end

      it "should not include microposts of another user" do
        mp3 = Factory(:micropost,
                      :user => Factory(:user, :email => Factory.next(:email)))
        @user.feed.include?(mp3).should be_false
      end
    end
  end







end