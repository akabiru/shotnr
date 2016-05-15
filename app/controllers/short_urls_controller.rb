class ShortUrlsController < ApplicationController
  before_action :set_short_url, only: [:edit, :update, :destroy]
  before_action :set_my_shotlinks, only: [:update, :destroy]

  def index
    @popular_shotlinks =
      OriginalUrl.where("clicks >= ?", 1).order(clicks: :desc)
    @recent_shotlinks = OriginalUrl.order(created_at: :desc)
    @influential_users = User.order(total_clicks: :desc)
    if logged_in?
      @my_shotlinks =
        ShortUrl.where(user_id: current_user.id).order(created_at: :desc)
    end
  end

  def update
    @short_url.original_url.update_attributes(
      long_url: short_url_params[:original_url_attributes][:long_url],
      active: short_url_params[:original_url_attributes][:active]
    )
    @short_url.update_attributes(
      vanity_string: short_url_params[:vanity_string]
    )
    respond_to :js
  end

  def destroy
    @short_url.destroy
    respond_to :js
  end

  def check_vanity_string
    exists = ShortUrl.exists?(vanity_string: params[:vanity_string_])
    respond_to do |format|
      format.json { render json: { exists:  exists } }
    end
  end

  def set_my_shotlinks
    @my_shotlinks =
        ShortUrl.where(user_id: current_user.id).order(created_at: :desc)
  end

  private

  def set_short_url
    @short_url = ShortUrl.find(params[:id])
  end

  def short_url_params
    params.require(:short_url).permit(:vanity_string, :long_url,
      original_url_attributes: [:long_url, :id, :active]
    )
  end
end
