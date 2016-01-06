class StaticPagesController < ApplicationController
  def home
    @entry = Entry.new
    if signed_in?
      @micropost = current_user.microposts.build
      @feed_items = current_user.feed.page(params[:page])
    end
  end

  def chat
  end

  def help
  end

  def about
  end

  def contact
  end

end
