class SessionsController < ApplicationController

  def new
  end

  def create
    #user = User.find_by_email(email: params[:session][:email].downcase)
    #user = User.find_by_email(:email)
    #user = User.authenticate( params[:session][:email], params[:session][:password] )
    #if user && user.authenticate(params[:session][:password])
    #  # Log the user in and redirect to the user's show page.
    #  log_in user
    #  redirect_to user
    #else
    #  flash.now[:danger] = 'Invalid email/password combination' # Not quite right!
    #  @title = "Sign in"
    #  render 'new'
    #end

    user = User.authenticate( params[:session][:email], params[:session][:password] )

    if user.nil?
      flash.now[:error] = "Invalid email/password combination."
      @title = "Sign in"
      render 'new'
    else
      sign_in user
      #params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      redirect_to user
    end
  end

  def destroy
    sign_out
    redirect_to root_path
  end
end
