class StaticPagesController < ApplicationController
  def home
    @micropost = Micropost.published.last
    if @micropost.content.to_s.length < 2500
      @prev_micropost = @micropost.prev
    end
    aside_settings
  end

  def about
    aside_settings
  end
end
