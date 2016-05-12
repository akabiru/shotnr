class OriginalUrlsController < ApplicationController
  def index
    @original_urls = OriginalUrl.all
  end

  def create
    @original_url = OriginalUrl.new(long_url: url_params[:long_url])
    respond_to do |format|
      if @original_url.save
        short_url = @original_url.build_short_url
        if logged_in?
          short_url.user_id = current_user.id
          if url_params[:vanity_string].blank?
            short_url.generate_short_url
          else
            short_url.vanity_string = url_params[:vanity_string]
          end
        else
          short_url.generate_short_url
        end
        short_url.save
      else
        format.html do
          render :index, danger: "Error, the url could not be saved."
        end
      end
      format.js {}
    end
  end

  def redirect_to_original_url
    original_url = OriginalUrl.find_long_url(params[:vanity_string])
    if original_url
      redirect_to original_url.long_url
      original_url.increment_clicks
      unless original_url.short_url.user.nil?
        original_url.short_url.user.increment_total_clicks
      end
    end
  end

  private

  def url_params
    params.require(:original_url).permit(:long_url, :vanity_string)
  end
end
