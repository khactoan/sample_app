class UsersController < ApplicationController
  def show
    @user = User.find_by id: params[:id]

    return if @user
    flash[:warning] =  t "can_not_find_user"
    redirect_to root_path
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params

    if @user.save
      log_in @user
      flash[:success] = t "welcone_to_sample_app"
      redirect_to @user
    else
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit :name, :email, :password,
      :password_confirmation
  end
end