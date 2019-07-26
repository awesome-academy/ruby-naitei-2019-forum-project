class SearchsController < ApplicationController
  def new
    @forums = load_records SubForum
    @posts = load_records Post
  end

  private

  def load_records resources
    Kaminari.paginate_array(resources.search(params[:q]))
      .page(params[:page]).per Settings.records_per_page
  end

  def search_params
    params.permit :q
  end
end
