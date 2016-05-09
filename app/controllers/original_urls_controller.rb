class OriginalUrlsController < ApplicationController
  def index
    @original_urls = OriginalUrl.all
  end

  def create
    @original_url = OriginalUrl.new(long_url: url_params[:long_url])
    if url_params[:vanity_string].nil?
      create_without_custom_url
    elsif logged_in? && url_params[:vanity_string].empty?
      create_without_custom_url
    else
      create_with_custom_url
    end
    respond_to :js
  end

  def redirect_to_original_url
    original_url = OriginalUrl.find_long_url(params[:vanity_string])
    redirect_to original_url.long_url if original_url
  end

  def create_without_custom_url
    if @original_url.save
      short_url = ShortUrl.new(original_url_id: @original_url.id)
      short_url.user_id = current_user.id if logged_in?
      short_url.generate_short_url
    else
      handle_create_failure
    end
  end

  def create_with_custom_url
    if @original_url.save
      short_url = ShortUrl.new(
        original_url_id: @original_url.id,
        vanity_string: url_params[:vanity_string]
      )
      short_url.user_id = current_user.id if logged_in?
      handle_create_failure unless short_url.save
    else
      handle_create_failure
    end
  end

  def handle_create_failure
    flash[:danger] = 'Error, the url could not be saved.'
    render :index
  end

  private

  def url_params
    params.require(:original_url).permit(:long_url, :vanity_string)
  end
end
