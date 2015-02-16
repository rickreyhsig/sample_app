class MicropostsController < ApplicationController
  #before_action :logged_in_user, only: [:create, :destroy]
  before_filter :authenticate

  def index
  end

  def create
    @micropost = current_user.microposts.build(params[:micropost])
    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to root_path
    else
      render 'static_pages/home'
    end
  end

  def destroy
  end
end
