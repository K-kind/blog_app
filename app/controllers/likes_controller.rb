class LikesController < ApplicationController
  before_action :logged_in_user

  def create
    @micropost = Micropost.find(params[:micropost_id])
    like = current_user.likes.build
    like.micropost = @micropost
    like.save
    respond_to do |format|
      format.html { redirect_to @micropost }
      format.js
    end
  end

  def destroy
    @micropost = Micropost.find(params[:micropost_id])
    current_user.post_like(@micropost).destroy
    respond_to do |format|
      format.html { redirect_to @micropost }
      format.js
    end
  end

end
