class ShortUrlsController < ApplicationController
  before_action :set_short_url, only: [:edit, :update]

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
