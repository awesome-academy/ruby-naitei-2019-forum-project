class MembersController < ApplicationController
  before_action :logged_in_user
  before_action :load_forum, only: :create
  before_action :load_member, only: :destroy

  def create
    current_user.join @forum, Settings.member_forum

    respond_to do |format|
      format.html{redirect_back fallback_location: root_url}
      format.js
    end
  end

  def update
    member = Member.find_by id: params[:id]

    if member.nil?
      flash[:warning] =  t "error_occurred"
      redirect_to request.referer
      return
    end

    if member.update_attributes user_type: params[:member][:user_type]
      flash[:success] = t "success"
    else
      flash[:warning] = t "error_occurred"
    end

    redirect_to request.referrer
  end

  def destroy
    @forum_id = @member.sub_forum_id
    forum = SubForum.find @forum_id
    current_user.leave forum

    respond_to do |format|
      format.html{redirect_back fallback_location: root_url}
      format.js
    end
  end

  private

  def load_member
    @member = Member.find_by id: params[:id]
    redirect_to root_url unless @member
  end

  def load_forum
    @forum = SubForum.find_by id: params[:sub_forum_id]
    return if @forum
    flash[:warning] = t ".not_a_forum_warning"
    redirect_to root_url
  end

  def store_current_location
    session[:forwarding_url] = request.referrer
  end

  def logged_in_user
    return if logged_in?
    store_current_location
    flash[:warning] = t "please_log_in"
    redirect_to login_url
  end
end
