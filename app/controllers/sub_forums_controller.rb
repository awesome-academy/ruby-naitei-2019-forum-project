class SubForumsController < ApplicationController
  before_action :find_forum_by_id, only: %i(show destroy)
  before_action :check_correct_user, only: :destroy

  def new
    @sub_forum = SubForum.new
  end

  def create
    @sub_forum = current_user.sub_forums.build sub_forum_params
    
    if @sub_forum.save
      redirect_to @sub_forum
    else
      render :new
    end
  end

  def show; end

  def destroy
    @sub_forum.destroy
    redirect_to request.referrer || root_url
  end

  private

  def sub_forum_params
    params.require(:sub_forum).permit %i(name description)
  end

  def check_correct_user
    return if current_user == @sub_forum.user
    flash[:danger] = t ".not_authorized"
    redirect_to root_url
  end

  def find_forum_by_id
    @sub_forum = SubForum.find_by(params[:id])
    return if @sub_forum
    flash[:danger] = t ".sub_forum_not_found"
    redirect_to root_url
  end
end
