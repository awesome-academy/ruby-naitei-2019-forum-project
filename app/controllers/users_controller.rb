class UsersController < ApplicationController
  before_action :logged_in_user, only: :update
  before_action :load_user, only: %i(show show_created_sub_forums update)
  before_action :correct_user, only: :update

  def show; end

  def show_created_sub_forums
    @sub_forums = @user.sub_forums
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params

    if @user.save
      UserMailer.account_activation(@user).deliver_now
      flash[:notice] = t ".account_activation"
      redirect_to root_url
    else
      render :new
    end
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = t ".profile_updated"
      redirect_to @user
    else
      render "show"
    end
  end

  def edit; end

  private

  def load_user
    @user = User.find_by id: params[:id]

    return if @user
    flash[:warning] = t ".user_not_found"
    redirect_to root_url
  end

  def user_params
    params.require(:user)
          .permit %i(avatar name email password password_confirmation)
  end

  def correct_user
    return if current_user? @user
    flash[:warning] = t "not_authorized"
    redirect_to root_url
  end
end
