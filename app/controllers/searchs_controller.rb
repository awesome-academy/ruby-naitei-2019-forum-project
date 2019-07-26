class SearchsController < ApplicationController
  def new
    @forums = SubForum.search params[:q]
    @posts = Post.search params[:q]
  end

  private

  def search_params
    params.permit :q
  end
end
