require "rails_helper"

RSpec.describe LinksController, type: :controller do
  let(:user) { create(:user) }

  before(:each) do
    allow_any_instance_of(ApplicationController).
      to receive(:current_user).and_return(user)
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
      expect(assigns(:links)).to eq(Link.all)
    end
  end

  describe 'POST #create' do
    before(:each) { @link_count = Link.count }

    context "when logged in" do
      context "when vanity string is blank" do
        it "generates a vanity string" do
          link = build(:link, user: user)
          post :create,
               link: {
                 actual: link.actual
               }, format: :js
          expect(Link.count).to eq(@link_count + 1)
          expect(assigns(:link).vanity_string).not_to be_nil
          expect(assigns(:link).user).to eq(user)
        end
      end

      context "when vanity string exists" do
        it "creates a new link  with the vanity string" do
          link = build(:link, user: user)
          post :create,
               link: {
                 actual: link.actual,
                 vanity_string: "facebook"
               }, format: :js
          expect(Link.count).to eq(@link_count + 1)
          expect(assigns(:link).vanity_string).to eq("facebook")
          expect(assigns(:link).user).to eq(user)
        end
      end
    end

    context "when logged out" do
      it "creates link with auto-generated vanity string" do
        allow_any_instance_of(ApplicationController).
          to receive(:current_user).and_return(nil)
        link = build(:link, user: nil)
        post :create,
             link: {
               actual: link.actual
             }, format: :js
        expect(assigns(:link).actual).to eq(link.actual)
        expect(Link.count).to eq(@link_count + 1)
        expect(assigns(:link).vanity_string).not_to be_nil
      end
    end
  end

  describe "GET #redirect_to_actual_link" do
    context "when the record is found" do
      context "when link is ours" do
        it "renders the index page" do
          link = create(:link, actual: "http://shotnr.com", user: nil)
          expect(
            get(:redirect_to_actual_link, vanity_string: link.vanity_string)
          ).to render_template(:index)
        end
      end

      context "when link is active" do
        before(:each) { @link = create(:link, user: nil) }

        it "redirects to the actual url" do
          get :redirect_to_actual_link, vanity_string: @link.vanity_string
          expect(response.status).to eq(302)
        end

        it "increments clicks" do
          link_clicks = @link.clicks
          get :redirect_to_actual_link, vanity_string: @link.vanity_string
          expect(Link.first.clicks).to eq(link_clicks + 1)
        end
      end

      context "when link is inactive" do
        before(:each) { @link = create(:link, active: false, user: nil) }

        it "redirects to inactive page" do
          get :redirect_to_actual_link, vanity_string: @link.vanity_string
          expect(response).to redirect_to(inactive_path)
        end

        it "does not increment clicks" do
          link_clicks = @link.clicks
          get :redirect_to_actual_link, vanity_string: @link.vanity_string
          expect(Link.first.clicks).to eq(link_clicks)
        end
      end
    end

    context "when the record is not found" do
      it "redirects to '/not_found'" do
        expect(
          get(:redirect_to_actual_link, vanity_string: "nothing")
        ).to redirect_to(not_found_url)
      end
    end
  end
end
