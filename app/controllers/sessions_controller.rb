class SessionsController < ApplicationController

  def new
  end

  def create
  	# Grab the user from the database using the email in the :session hash
  	user = User.find_by_email(params[:session][:email].downcase)
  	if user && user.authenticate(params[:session][:password])
  	  # Sign the user in and redirect to user's show page
  	  sign_in user
  	  redirect_back_or user
  	else
  	  # Create an error message and re-render the sign in form
  	  flash.now[:error] = "Invalid email/password combination"
  	  render 'new'
  	end
  end

  def destroy
  	sign_out
  	redirect_to root_url
  end
end
