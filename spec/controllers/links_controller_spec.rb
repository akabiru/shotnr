require "rails_helper"

RSpec.describe LinksController, type: :controller do
  let(:user) { create(:user) }

  before(:each) { stub_current_user(user) }

  describe 'GET #new' do
    before { get :new }

    it "renders the new page" do
      expect(response).to render_template(:new)
    end

    it "returns a status code 200" do
      expect(response.status).to eq(200)
    end
  end

  describe 'GET #index' do
    before { get :index }

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
    let(:link) { build(:link, user: user) }

    context "when logged in" do
      context "when vanity string is blank" do
        it "generates a vanity string" do
          expect do
            post :create, link: { actual: link.actual }, format: :js
          end.to change(Link, :count).by(1)
          expect(assigns(:link).vanity_string).not_to be_nil
          expect(assigns(:link).user).to eq(user)
        end
      end

      context "when vanity string exists" do
        it "creates a new link  with the vanity string" do
          expect do
            post :create,
                 link: {
                   actual: link.actual,
                   vanity_string: "facebook"
                 },
                 format: :js
          end.to change(Link, :count).by(1)
          expect(assigns(:link).vanity_string).to eq("facebook")
          expect(assigns(:link).user).to eq(user)
        end
      end
    end

    context "when logged out" do
      before do
        stub_current_user(nil)
        link.update(user: nil)
      end

      it "creates link with auto-generated vanity string" do
        expect do
          post :create, link: { actual: link.actual }, format: :js
        end.to change(Link, :count).by(1)
        expect(assigns(:link).actual).to eq(link.actual)
        expect(assigns(:link).vanity_string).not_to be_nil
      end
    end
  end

  describe "GET #redirect_to_actual_link" do
    let(:link) { create(:link, user: nil) }

    context "when the record is found" do
      context "when link is ours" do
        before { link.update(actual: "http://shotnr.com") }

        it "renders the index page" do
          expect(
            get(:redirect_to_actual_link, vanity_string: link.vanity_string)
          ).to render_template(:index)
        end
      end

      context "when link is active" do
        it "redirects to the actual url" do
          get :redirect_to_actual_link, vanity_string: link.vanity_string
          expect(response.status).to eq(302)
        end

        it "increments clicks" do
          link_clicks = link.clicks
          get :redirect_to_actual_link, vanity_string: link.vanity_string
          expect(Link.first.clicks).to eq(link_clicks + 1)
        end
      end

      context "when link is inactive" do
        before { link.update(active: false) }

        it "redirects to inactive page" do
          get :redirect_to_actual_link, vanity_string: link.vanity_string
          expect(response).to redirect_to(inactive_path)
        end

        it "does not increment clicks" do
          link_clicks = link.clicks
          get :redirect_to_actual_link, vanity_string: link.vanity_string
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
