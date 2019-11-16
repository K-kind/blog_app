class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper

  private

  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = "Please log in"
      redirect_to login_url
    end
  end

  def aside_settings
    @first_user = User.first
    @popular_posts = Micropost.order('impressions_count DESC').take(3)
    @nov_posts = Micropost.where("created_at BETWEEN '2019/11/01 00:00:00' AND '2019/12/01 00:00:00'")
    @dec_posts = Micropost.where("created_at BETWEEN '2019/12/01 00:00:00' AND '2020/01/01 00:00:00'")
    @jan_posts = Micropost.where("created_at BETWEEN '2020/01/01 00:00:00' AND '2020/02/01 00:00:00'")
    @feb_posts = Micropost.where("created_at BETWEEN '2020/02/01 00:00:00' AND '2020/03/01 00:00:00'")
    @categories = Micropost.all.select(:category).distinct
  end
end
