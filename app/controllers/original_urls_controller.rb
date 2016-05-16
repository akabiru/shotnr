class OriginalUrlsController < ApplicationController
  def index
    @original_urls = OriginalUrl.all
    respond_to do |format|
      format.html { render :index }
      format.json { render json: @original_urls.as_json }
    end
  end

  def create
    @original_url = OriginalUrl.new(long_url: url_params[:long_url])
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
      respond_to do |format|
        format.js {}
      end
    else
      flash[:danger] = "Error, shotlink could not be saved."
      render :index
    end
  end

  def redirect_to_original_url
    original_url = OriginalUrl.find_long_url(params[:vanity_string])
    if original_url && original_url.active?
      redirect_to original_url.long_url, status: 302
      original_url.increment_clicks
      unless original_url.short_url.user.nil?
        original_url.short_url.user.increment_total_clicks
      end
    elsif original_url && original_url.inactive?
      render :inactive_page
    else
      render :deleted_page
    end
  end

  def inactive_page
  end

  def deleted_page
  end

  private

  def url_params
    params.require(:original_url).permit(:long_url, :vanity_string)
  end
end
