class LinksController < ApplicationController
  def new
    @link = Link.new
  end

  def index
    @links = Link.all
    @popular = Link.where("clicks >= ?", 1).order(clicks: :desc)
    @recent = Link.order(created_at: :desc)
    @top_users = nil
    @user_links = current_user.links.order(created_at: :desc) if logged_in?
  end

  def create
    @link = Link.new(url_params)
    @link.user_id = current_user.id if logged_in?
    @link.save
    respond_to :js
  end

  def redirect_to_actual_link
    link = Link.find_by(vanity_string: params[:vanity_string]) or not_found
    render :index if link.ours?
    if link.active?
      redirect_to link.actual, status: 302
      link.increment_clicks
    elsif link.inactive?
      render :inactive_page
    else
      render :deleted_page
    end
  end

  def not_found
    raise ActiveRecord::RecordNotFound.new('Not Found')
  end

  def inactive_page
  end

  def deleted_page
  end

  private

  def url_params
    params.require(:link).permit(:actual, :vanity_string)
  end
end
