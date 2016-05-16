require 'rails_helper'

RSpec.describe OriginalUrlsController,type: :controller do
  before(:each) do
    @user = create(:user)
    allow_any_instance_of(ApplicationController).
      to receive(:current_user).and_return(@user)
  end

  describe 'GET #index' do
    before(:each) { get :index }

    it 'renders the index page' do
      expect(response).to render_template(:index)
    end

    it 'returns a status code 200' do
      expect(response.status).to eq(200)
    end

    it "assigns all original_urls to @original_urls" do
      original_urls = OriginalUrl.all
      expect(assigns(:original_urls)).to eq(original_urls)
    end
  end

  describe 'POST #create' do
    before(:each) do
      @original_url_count = OriginalUrl.count
      @short_url_count = ShortUrl.count
    end

    context 'when logged in' do
      context 'vanity string is blank' do
         it 'should create create a new original url and short_url' do
          original_url = build(:original_url)
          post :create, original_url: { long_url: original_url.long_url}, format: :js
          expect(assigns(:original_url).long_url).to eq(original_url.long_url)
          expect(OriginalUrl.count).to eq(@original_url_count + 1)
          expect(ShortUrl.count).to eq(@short_url_count + 1)
        end
      end

      context 'vanity string exists' do
        it 'should create a new original url and short url with vanity string' do
          original_url = build(:original_url)
          post :create,
          original_url: {
            long_url: original_url.long_url,
            vanity_string: 'facebook'
          }, format: :js
          expect(assigns(:original_url).long_url).to eq(original_url.long_url)
          expect(
            assigns(:original_url).short_url.vanity_string
          ).to eq('facebook')
          expect(OriginalUrl.count).to eq(@original_url_count + 1)
          expect(ShortUrl.count).to eq(@short_url_count + 1)
        end
      end
    end

    context 'when logged out' do
      it 'should create a new original url and a short_url' do
        allow_any_instance_of(ApplicationController).
          to receive(:current_user).and_return(nil)
        original_url = build(:original_url)
        post :create, original_url: { long_url: original_url.long_url}, format: :js
        expect(assigns(:original_url).long_url).to eq(original_url.long_url)
        expect(OriginalUrl.count).to eq(@original_url_count + 1)
        expect(ShortUrl.count).to eq(@short_url_count + 1)
      end
    end
  end

end
