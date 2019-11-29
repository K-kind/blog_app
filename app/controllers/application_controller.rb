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
    @admin_user = User.find_by(admin: true)
    @popular_posts = Micropost.published.order('impressions_count DESC').take(3)
    @nov_posts = Micropost.published.where("created_at BETWEEN '2019/11/01 00:00:00' AND '2019/12/01 00:00:00'")
    @dec_posts = Micropost.published.where("created_at BETWEEN '2019/12/01 00:00:00' AND '2020/01/01 00:00:00'")
    @jan_posts = Micropost.published.where("created_at BETWEEN '2020/01/01 00:00:00' AND '2020/02/01 00:00:00'")
    @feb_posts = Micropost.published.where("created_at BETWEEN '2020/02/01 00:00:00' AND '2020/03/01 00:00:00'")
    @categories = Micropost.published.select(:category).distinct
  end

  def admin_user
    redirect_to(root_url) unless current_user&.admin?
  end
end
