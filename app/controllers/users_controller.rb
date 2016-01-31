class UsersController < ApplicationController
  # GET /users
  # GET /users.xml

  before_filter :authenticate, :only => [:index, :edit, :update, :destroy]
  before_filter :correct_user, :only => [:edit, :update]
  before_filter :admin_user,   :only => :destroy

  def index
    @title = "Users list"
    @users = User.paginate(:page => params[:page])
    # $users = User.all

    flash[:success] = "signed in"

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @users }
    end
  end

  # GET /users/1
  # GET /users/1.xml
  def show
    @user = User.find(params[:id])
    @title = @user.nom

    @microposts = @user.microposts.paginate(:page => params[:page])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/new
  # GET /users/new.xml
  def new
    @user = User.new
    @title = "Sign up"

    respond_to do |format|
     format.html # new.html.erb
     format.xml  { render :xml => @user }
    end
  end

  # GET /users/1/edit
  def edit
   # @user = User.find(params[:id])
    @title = "Profile edit"

    if @user.update_attributes(params[:user])
      flash[:success] = "updated"
      redirect_to @user
    else
      @title = "Profile edit"
      render 'edit'
    end
  end

  # POST /users
  # POST /users.xml
  def create
    @user = User.new(params[:user])
    @title = "Sign up"

    respond_to do |format|
      if @user.save
        sign_in @user
        flash[:success] = "Welcome to Example Application !"
        format.html { redirect_to(@user, :notice => 'User was successfully created.') }
        format.xml  { render :xml => @user, :status => :created, :location => @user }
      else
        @title = "Sign up"
        format.html { render :action => "new" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.xml
  def update
   # @user = User.find(params[:id])
    @title = "Profile edit"

    respond_to do |format|
      if @user.update_attributes(params[:user])
        flash[:success] = "updated"
        format.html { redirect_to(@user, :notice => 'User was successfully updated.') }
        format.xml  { head :ok }
      else
        @title = "Profile edit"
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    @user = User.find(params[:id])
    @user.destroy
    flash[:success] = "User deleted"


    respond_to do |format|
      format.html { redirect_to(users_url) }
      format.xml  { head :ok }
    end
  end

  private

  #def authenticate
   # deny_access unless signed_in?
  #end

  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_path) unless current_user?(@user)
  end

  def admin_user
    redirect_to(root_path) unless current_user.admin?
  end

end
