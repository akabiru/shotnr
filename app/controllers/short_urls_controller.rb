class ShortUrlsController < ApplicationController
  before_action :set_short_url, only: [:edit, :update]

  def index
    @popular_shotlinks =
      OriginalUrl.where("clicks >= ?", 1).order(clicks: :desc).limit(7)
    @recent_shotlinks = OriginalUrl.order(created_at: :desc).limit(7)
    @influential_users = User.order(total_clicks: :desc).limit(7)
    @my_shotlinks = current_user.short_urls if logged_in?
  end

  def update
    @short_url.original_url.update_attributes(short_url_params[:long_url])
    @short_url.update_attributes(short_url_params[:vanity_string])
    respond_to do |format|
      format.js {}
    end
  end

  def check_vanity_string
    exists = ShortUrl.exists?(vanity_string: params[:vanity_string_])
    respond_to do |format|
      format.json { render json: { exists:  exists } }
    end
  end

  private

  def set_short_url
    @short_url = ShortUrl.find(params[:id])
  end

  def short_url_params
    params.require(:short_url).permit(:vanity_string, :long_url)
  end
end
