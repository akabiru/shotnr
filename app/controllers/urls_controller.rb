class UrlsController < ApplicationController
  def index
    @urls = Url.all
  end

  def create
    @url = Url.new(url_params)
    respond_to do |format|
      @url.save
      format.js
    end
  end

  def redirect
    @url = Url.base_decode(params[:short_url])
    redirect_to @url.long_url
    @url.increment_hits
  end

  private
    def url_params
      params.require(:url).permit(:long_url)
    end

end
