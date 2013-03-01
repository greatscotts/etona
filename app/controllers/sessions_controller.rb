  class SessionsController < ApplicationController
  def new
    @title ="Sign In"
  end

  def create
    user = User.find_by_username(params[:session][:username])
    if user && user.authenticate(params[:session][:password])
      sign_in user
      redirect_to root_url
    else
      flash.now[:error] = "Invalid username/password combination."
      render 'new'
    end
  end

  def destroy
    sign_out
    redirect_to root_path
  end

  def create_mobile
    user = User.find_by_username(params[:sessions][:username])
    if user && user.authenticate(params[:sessions][:password])
      sign_in user
      redirect_to '/home'
    else
      flash.now[:error] = "Invalid username/password combination."
      render 'new'
    end
  end

  def create_post
    user = User.find_by_username(params[:sessionss][:username])
    if user && user.authenticate(params[:sessionss][:password])
      sign_in user
      redirect_to '/post'
    else
      flash.now[:error] = "Invalid username/password combination."
      render 'new'
    end
  end
end
