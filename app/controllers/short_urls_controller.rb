class ShortUrlsController < ApplicationController
  before_action :set_short_url, only: [:edit, :update]

  def index
    @popular_shotlinks =
      OriginalUrl.where("clicks >= ?", 1).order(clicks: :desc).limit(7)
    @recent_shotlinks = OriginalUrl.order(created_at: :desc).limit(7)
    @influential_users = User.order(total_clicks: :desc).limit(7)
  end

  def edit
  end

  def update
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
end
