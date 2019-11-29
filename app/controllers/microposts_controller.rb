class MicropostsController < ApplicationController
  before_action :logged_in_user, except: [:show, :index, :categories, :search]
  before_action :correct_user, only: [:destroy, :edit, :update]
  before_action :admin_user, only: [:drafts]

  def index
    @microposts = Micropost.published.paginate(page: params[:page]).order(id: "DESC")
    aside_settings
  end

  def new
    @micropost = current_user.microposts.build
  end

  def create
    @micropost = current_user.microposts.build(micropost_params)
    @micropost.content_string = @micropost.content.to_s
    if @micropost.save
      case params[:micropost][:draft]
      when '0'
        flash[:success] = "投稿が完了しました"
        redirect_to @micropost
      when '1'
        @micropost.update_attributes(draft: true)
        flash[:success] = "下書きが保存されました"
        redirect_to drafts_microposts_url
      end
    else
      render 'new'
    end
  end

  def show
    @micropost = Micropost.published.find(params[:id])
    impressionist(@micropost, nil, unique: [:session_hash])
    @comments = @micropost.comments.where(replied_id: nil).paginate(page: params[:page], :per_page => 8)
    @comment = Comment.new
    aside_settings
  end

  def destroy
    @micropost.destroy
    flash[:success] = "投稿が削除されました"
    redirect_to root_url
  end

  def edit
  end

  def update
    if @micropost.update_attributes(micropost_params)
      @micropost.update_attributes(content_string: @micropost.content.to_s)
      case params[:micropost][:draft]
      when nil
        flash[:success] = "投稿が更新されました"
        redirect_to @micropost
      when '0'
        @micropost.update_attributes(draft: false, created_at: Time.zone.now)
        flash[:success] = "投稿が完了しました"
        redirect_to @micropost
      when '1'
        flash[:success] = "下書きが保存されました"
        redirect_to drafts_microposts_url
      end
    else
      render 'edit'
    end
  end

  def categories
    @category = params[:category]
    @microposts = Micropost.published.where(category: @category).paginate(page: params[:page]).order(id: "DESC")
    aside_settings
  end

  def search
    @search = params[:search]
    @microposts = Micropost.published.search(@search).paginate(page: params[:page]).order(id: "DESC")
    aside_settings
  end

  def drafts
    @draft_posts = Micropost.where(draft: true).paginate(page: params[:page])
    aside_settings
  end

  private

    def micropost_params
      params.require(:micropost).permit(:content, :title, :category, :image)
    end

    def correct_user
      @micropost = current_user.microposts.find_by(id: params[:id])
      redirect_to root_url if @micropost.nil?
    end
end
