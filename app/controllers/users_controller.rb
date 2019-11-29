class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy, :following, :followers]
  before_action :correct_user, only: [:edit, :update, :destroy]
  before_action :admin_user, only: [:index]

  def index
    @users = User.where(activated: true).paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
    @comments = @user.comments.select(:micropost_id).distinct.paginate(page: params[:page])
    redirect_to root_url and return unless @user.activated?
    aside_settings
  end

  def new
    @user = User.new
  end

  def following
    @title = "Following"
    @user  = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user  = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = "認証メールを送信しました。登録を完了するためにメールをご確認ください。"
      redirect_to root_url
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    if @user.admin?
      flash[:danger] = "管理ユーザーは削除することができません"
      redirect_to root_url
      return
    end
    @user.destroy
    flash[:success] = "User deleted"
    redirect_to root_url
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :profile_image, :introduction)
    end

    def correct_user
      @user = User.find(params[:id])
      unless current_user?(@user) || current_user.admin? 
        redirect_to(root_url)
      end
    end
end
