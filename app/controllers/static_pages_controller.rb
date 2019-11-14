class StaticPagesController < ApplicationController
  def home
    @micropost = Micropost.last
    if @micropost.content.to_s.length < 2500
      @prev_micropost = @micropost.prev
    end
    @popular_posts = Micropost.order('impressions_count DESC').take(3)
    @all_posts = Micropost.all
    @nov_posts = Micropost.where("created_at BETWEEN '2019/11/01 00:00:00' AND '2019/12/01 00:00:00'")
    @dec_posts = Micropost.where("created_at BETWEEN '2019/12/01 00:00:00' AND '2020/01/01 00:00:00'")
    @jan_posts = Micropost.where("created_at BETWEEN '2020/01/01 00:00:00' AND '2020/02/01 00:00:00'")
    @feb_posts = Micropost.where("created_at BETWEEN '2020/02/01 00:00:00' AND '2020/03/01 00:00:00'")
  end

  def about
  end
end
