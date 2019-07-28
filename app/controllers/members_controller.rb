class MembersController < ApplicationController
  before_action :logged_in_user
  before_action :load_user, only: :create
  before_action :load_member, only: :destroy

  def create
    @forum_id = @forum.id
    current_user.join @forum

    respond_to do |format|
      format.html{redirect_back fallback_location: root_url}
      format.js
    end
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
    redirect_to root_url if @member.nil?
  end

  def load_user
    @forum = SubForum.find_by id: params[:sub_forum_id]
    flash[:notice] = ".not_a_forum_warning"
    redirect_to root_url if @forum.nil?
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
