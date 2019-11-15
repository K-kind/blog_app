class CommentsController < ApplicationController
  before_action :logged_in_user
  before_action :correct_commenter, only: [:destroy, :update]

  def create
    @comment = current_user.comments.build(comment_params)
    @comment.micropost_id = params[:micropost_id]
    if @comment.save
      flash[:success] = "Successfully commented."
      redirect_to @comment.micropost
    else
      @micropost = Micropost.find(params[:micropost_id])
      @comments = @micropost.comments.paginate(page: params[:page], :per_page => 8)
      impressionist(@micropost, nil, :unique => [:session_hash])
      aside_settings
      render 'microposts/show'
    end
  end

  def update
    @micropost = @comment.micropost
    if @comment.update_attributes(comment_params)
      @comment.save
      flash[:success] = "Comment updated"
      redirect_to @micropost
    else
      @comments = @micropost.comments.paginate(page: params[:page], :per_page => 8)
      impressionist(@micropost, nil, :unique => [:session_hash])
      aside_settings
      render 'microposts/show'
    end
  end

  def destroy
    micropost = @comment.micropost
    @comment.destroy
    flash[:success] = "Comment deleted"
    redirect_to micropost
  end

  private
    def comment_params
      params.require(:comment).permit(:content)
    end

    def correct_commenter
      @comment = Comment.find_by(id: params[:id])
      unless current_user == @comment.user || current_user.admin?
        redirect_to root_url
      end
    end
end