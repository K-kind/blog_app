class MicropostsController < ApplicationController
  before_action :logged_in_user, except: [:show, :index]
  before_action :correct_user, only: [:destroy, :edit, :update]
  impressionist :actions=> [:show]

  def index
    @microposts = Micropost.paginate(page: params[:page]).order(id: "DESC")
    aside_settings
  end

  def new
    @micropost = current_user.microposts.build
  end

  def create
    @micropost = current_user.microposts.build(micropost_params)
    @micropost.content_string = @micropost.content.to_s
    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to @micropost
    else
      render 'new'
    end
  end

  def show
    @micropost = Micropost.find(params[:id])
    impressionist(@micropost, nil, :unique => [:session_hash])
    @comments = @micropost.comments.paginate(page: params[:page], :per_page => 8)
    @comment = Comment.new
    aside_settings
  end

  def destroy
    @micropost.destroy
    flash[:success] = "Micropost deleted"
    redirect_to root_url
  end

  def edit
  end

  def update
    if @micropost.update_attributes(micropost_params)
      @micropost.content_string = @micropost.content.to_s
      @micropost.save
      flash[:success] = "Post updated"
      redirect_to @micropost
    else
      render 'edit'
    end
  end

  def categories
    @category = params[:category]
    @microposts = Micropost.where(category: @category).paginate(page: params[:page]).order(id: "DESC")
    aside_settings
  end

  def search
    @search = params[:search]
    @microposts = Micropost.search(@search).paginate(page: params[:page]).order(id: "DESC")
    aside_settings
  end

  private

    def micropost_params
      params.require(:micropost).permit(:content, :title, :category)
    end

    def correct_user
      @micropost = current_user.microposts.find_by(id: params[:id])
      redirect_to root_url if @micropost.nil?
    end
end
