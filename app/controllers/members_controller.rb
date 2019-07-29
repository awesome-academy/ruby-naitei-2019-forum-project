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
    redirect_to root_url unless @member
  end

  def load_user
    @forum = SubForum.find_by id: params[:sub_forum_id]
    flash[:notice] = ".not_a_forum_warning"
    redirect_to root_url unless @forum
  end
end
