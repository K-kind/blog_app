class MicropostsController < ApplicationController
  before_action :logged_in_user, except: [:show, :index]
  before_action :correct_user, only: [:destroy, :edit, :update]
  impressionist :actions=> [:show]

  def index
    @user = Micropost.last.user
    @microposts = Micropost.paginate(page: params[:page]).order(id: "DESC")
    @popular_posts = Micropost.order('impressions_count DESC').take(3)
    @nov_posts = Micropost.where("created_at BETWEEN '2019/11/01 00:00:00' AND '2019/12/01 00:00:00'")
    @dec_posts = Micropost.where("created_at BETWEEN '2019/12/01 00:00:00' AND '2020/01/01 00:00:00'")
    @jan_posts = Micropost.where("created_at BETWEEN '2020/01/01 00:00:00' AND '2020/02/01 00:00:00'")
    @feb_posts = Micropost.where("created_at BETWEEN '2020/02/01 00:00:00' AND '2020/03/01 00:00:00'")
    @all_posts = Micropost.all
  end
  def new
    @micropost = current_user.microposts.build
  end

  def create
    @micropost = current_user.microposts.build(micropost_params)
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
    @popular_posts = Micropost.order('impressions_count DESC').take(3)
    @nov_posts = Micropost.where("created_at BETWEEN '2019/11/01 00:00:00' AND '2019/12/01 00:00:00'")
    @dec_posts = Micropost.where("created_at BETWEEN '2019/12/01 00:00:00' AND '2020/01/01 00:00:00'")
    @jan_posts = Micropost.where("created_at BETWEEN '2020/01/01 00:00:00' AND '2020/02/01 00:00:00'")
    @feb_posts = Micropost.where("created_at BETWEEN '2020/02/01 00:00:00' AND '2020/03/01 00:00:00'")
    @all_posts = Micropost.all
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
      flash[:success] = "Post updated"
      redirect_to @micropost
    else
      render 'edit'
    end
  end

  def categories
    @category = params[:category]
    @microposts = Micropost.where(category: @category).paginate(page: params[:page]).order(id: "DESC")
    @user = @microposts.last.user
    @popular_posts = Micropost.order('impressions_count DESC').take(3)
    @nov_posts = Micropost.where("created_at BETWEEN '2019/11/01 00:00:00' AND '2019/12/01 00:00:00'")
    @dec_posts = Micropost.where("created_at BETWEEN '2019/12/01 00:00:00' AND '2020/01/01 00:00:00'")
    @jan_posts = Micropost.where("created_at BETWEEN '2020/01/01 00:00:00' AND '2020/02/01 00:00:00'")
    @feb_posts = Micropost.where("created_at BETWEEN '2020/02/01 00:00:00' AND '2020/03/01 00:00:00'")
    @all_posts = Micropost.all
  end

  def search
    @search = params[:search]
    @microposts = Micropost.search(@search).paginate(page: params[:page]).order(id: "DESC")
    @user = Micropost.last.user
    @popular_posts = Micropost.order('impressions_count DESC').take(3)
    @nov_posts = Micropost.where("created_at BETWEEN '2019/11/01 00:00:00' AND '2019/12/01 00:00:00'")
    @dec_posts = Micropost.where("created_at BETWEEN '2019/12/01 00:00:00' AND '2020/01/01 00:00:00'")
    @jan_posts = Micropost.where("created_at BETWEEN '2020/01/01 00:00:00' AND '2020/02/01 00:00:00'")
    @feb_posts = Micropost.where("created_at BETWEEN '2020/02/01 00:00:00' AND '2020/03/01 00:00:00'")
    @all_posts = Micropost.all
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
