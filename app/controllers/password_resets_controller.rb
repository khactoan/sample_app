class PasswordResetsController < ApplicationController
  before_action :load_user_by_email, only: %i(edit update)
  before_action :valid_user, only: %i(edit update)

  def new; end

  def create
    @user = User.find_by email: params[:password_reset][:email].downcase

    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = t ".email_sent_with_password_reset_instructions"
      redirect_to root_url
    else
      flash.now[:danger] = t ".email_address_not_found"
      render :new
    end
  end

  def update
    if params[:user][:password].empty?
      @user.errors.add :password, t(".can_not_be_empty")
      render :edit
    elsif @user.update_attributes user_params
      log_in @user
      @user.update_attribute :reset_digest, nil
      flash[:success] = t ".password_has_been_reset"
      redirect_to @user
    else
      render :edit
    end
  end

  private

  def load_user_by_email
    @user = User.find_by email: params[:email]

    return if @user
    flash[:warning] = t "can_not_find_user"
    redirect_to root_url
  end

  def valid_user
    unless @user && @user.activated? &&
      @user.authenticated?(:reset, params[:id])
      redirect_to root_url
    end
  end
end
