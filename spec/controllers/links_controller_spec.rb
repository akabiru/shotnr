require "rails_helper"

RSpec.describe LinksController, type: :controller do
  before(:each) do
    @user = create(:user)
    allow_any_instance_of(ApplicationController).
      to receive(:current_user).and_return(@user)
  end

  describe 'GET #new' do
    before(:each) { get :new }

    it "renders the new page" do
      expect(response).to render_template(:new)
    end

    it "returns a status code 200" do
      expect(response.status).to eq(200)
    end
  end

  describe 'GET #index' do
    before(:each) { get :index }

    it "renders the index page" do
      expect(response).to render_template(:index)
    end

    it "returns a status code 200" do
      expect(response.status).to eq(200)
    end

    it "assigns all links to @links" do
      links = Link.all
      expect(assigns(:links)).to eq(links)
    end
  end

  describe 'POST #create' do
    before(:each) { @link_count = Link.count }

    context "when logged in" do
      context "vanity string is blank" do
        it "should generate a vanity string" do
          link = build(:link, user: nil)
          post :create,
               link: {
                 actual: link.actual
               }, format: :js
          expect(assigns(:link).actual).to eq(link.actual)
          expect(Link.count).to eq(@link_count + 1)
        end
      end

      context "vanity string exists" do
        it "should create a new link  with the vanity string" do
          link = build(:link, user: nil)
          post :create,
               link: {
                 actual: link.actual,
                 vanity_string: "facebook"
               }, format: :js
          expect(assigns(:link).actual).to eq(link.actual)
          expect(
            assigns(:link).vanity_string
          ).to eq("facebook")
          expect(Link.count).to eq(@link_count + 1)
        end
      end
    end

    context "when logged out" do
      it "should create a new link" do
        allow_any_instance_of(ApplicationController).
          to receive(:current_user).and_return(nil)
        link = build(:link, user: nil)
        post :create,
             link: {
               actual: link.actual
             }, format: :js
        expect(assigns(:link).actual).to eq(link.actual)
        expect(Link.count).to eq(@link_count + 1)
      end
    end
  end

  describe "GET #redirect_to_actual_link" do
    it "should redirect_to not_found if record doesn't exist" do
      expect(
        get(:redirect_to_actual_link, vanity_string: "nothing")
      ).to redirect_to(not_found_url)
    end

    it "should render #index if link is ours" do
      link = create(:link, actual: "http://shotnr.com", user: nil)
      expect(
        get(:redirect_to_actual_link, vanity_string: link.vanity_string)
      ).to render_template(:index)
    end

    it "redirects to actual url if link is active" do
      link = create(:link, user: nil)
      get :redirect_to_actual_link, vanity_string: link.vanity_string
      expect(response.status).to eq(302)
    end

    it "increments clicks of active url" do
      link = create(:link, user: nil)
      expect(Link.first.clicks).to eq(0)
      get :redirect_to_actual_link, vanity_string: link.vanity_string
      expect(Link.first.clicks).to eq(1)
    end

    it "redirects to inactive page if link is inactive" do
      link = create(:link, active: false, user: nil)
      get :redirect_to_actual_link, vanity_string: link.vanity_string
      expect(response).to redirect_to(inactive_path)
    end
  end
end
