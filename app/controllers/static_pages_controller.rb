class StaticPagesController < ApplicationController
  def home
    # if logged_in?
    @micropost = Micropost.last
      # @feed_items = current_user.feed.paginate(page: params[:page])
    # end
  end

  def about
  end
end
