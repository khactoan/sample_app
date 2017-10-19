class UsersController < ApplicationController
  before_action :logged_in_user, except: %i(show new create)
  before_action :verify_admin!, only: :destroy
  before_action :load_user, except: %i(index new create)
  before_action :correct_user, only: %i(edit update)

  def index
    @users = User.select_id_name_email.activated.sort_by_created_at
      .paginate page: params[:page], per_page: Settings.per_page
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params

    if @user.save
      @user.send_activation_email
      flash[:info] = t ".please_check_your_mail_to_activate"
      redirect_to root_url
    else
      render :new
    end
  end

  def show
    @microposts = @user.microposts.order_by_created_at_desc
      .paginate page: params[:page], per_page: Settings.per_page
  end

  def update
    if @user.update_attributes user_params
      flash[:success] = t ".user_updated"
      redirect_to @user
    else
      flash.now[:danger] = t ".user_update_error"
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t ".user_deleted"
    else
      flash[:danger] = t ".user_delete_error"
    end
    redirect_to root_path
  end

  def following
    @title = t ".following"
    @users = @user.following.sort_by_created_at
      .paginate page: params[:page], per_page: Settings.per_page
    render :show_follow
  end

  def followers
    @title = t ".followers"
    @users = @user.followers.sort_by_created_at
      .paginate page: params[:page], per_page: Settings.per_page
    render :show_follow
  end

  private

  def verify_admin!
    redirect_to(root_url) unless current_user.is_admin?
  end

  def user_params
    params.require(:user).permit :name, :email, :password,
      :password_confirmation
  end

  def logged_in_user
    return if logged_in?
    flash.now[:danger] = t "please_log_in"
    redirect_to login_url
  end

  def load_user
    @user = User.find_by id: params[:id]

    return if @user
    flash[:warning] = t "can_not_find_user"
    redirect_to root_path
  end
end
