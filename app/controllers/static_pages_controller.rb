class StaticPagesController < ApplicationController

  def home
   @title = "Home"
   if signed_in?
      @micropost = Micropost.new
      #@feed_items = current_user.feed(:page => params[:page])
      @feed_items = current_user.feed
    end
  end

  def help
  end

  def about
  end

  def contact
  end
end
