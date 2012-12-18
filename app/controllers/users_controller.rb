class UsersController < ApplicationController
  before_filter :signed_out, only: [:new, :create]
  before_filter :signed_in_user, only: [:index, :edit, :update, :destroy]
  before_filter :correct_user, only: [:edit, :update]
  before_filter :admin_user, only: :destroy
  
  def index
    @users = User.paginate(page: params[:page])
  end

  def show
  	@user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  def new
  	@user = User.new
  end

  def create
  	@user = User.new(params[:user])
  	if @user.save
  	  sign_in @user
  	  flash[:success] = "Welcome to the Sample App!"
  	  redirect_to @user
  	else
  	  render 'new'
  	end
  end

  def edit
  	# before_filters :signed_in_user and :correct_user take care of grabbing the correct user and storing it in @user
  end

  def update
  	# before_filters :signed_in_user and :correct_user take care of grabbing the correct user and storing it in @user
  	if @user.update_attributes(params[:user])
  	  # Handle successful update
  	  flash[:success] = "Profile updated"
  	  sign_in @user
  	  redirect_to @user
  	else
  	  render 'edit'
  	end
  end

  def destroy
    @user = User.find(params[:id]) # Grab the user by id
    if current_user?(@user) # check to see if the user you're trying to destory is the current user, yourself
      redirect_to users_path, notice: "You can't destroy yourself." # redirect to the list of all users
    else
      @user.destroy
      flash[:success] = "User destroyed."
      redirect_to users_url
    end
  end

  private

    def signed_out
      redirect_to(root_path) if signed_in?
    end

    def signed_in_user
      unless signed_in?
      	store_location
        redirect_to signin_url, notice: "Please sign in."
      end
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end

end
