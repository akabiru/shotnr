require "rails_helper"

RSpec.feature do
  shared_examples "an anonymous user" do
    scenario "visits home page" do
      visit "/"
      expect(page).to have_selector("h3", "Welcome to Url  Shotnr!")
      expect(page).to have_css('input#link_actual')
      expect(page).to have_selector("a", "Shotlinks")
      expect(page).to have_selector("span", "Log In")
    end

    scenario "pastes a long url" do
      fill_in_long_url
      click_button "shotn!"
      expect(page).to have_selector("p", "https://www.google.com/")
    end

    scenario "clicks 'Shotlinks' link" do
      visit "/"
      click_link "Shotlinks"
      expect(
        page
      ).to have_content("Popular Recent  Top Users")
    end

    scenario "clicks 'Recent Shotlinks' tab" do
      fill_in_long_url
      click_button "shotn!"
      click_link "Shotlinks"
      click_link "Recent"
      expect(page).to have_content("https://www.google.com/")
    end
  end

  context "Anonymous User" do
    it_behaves_like "an anonymous user"
  end

  context "Logged in User" do
    it_behaves_like "an anonymous user"

    before(:each) { login_with_twitter }

    scenario "visits home page" do
      expect(page).to have_css("input#vanity-string")
    end

    scenario "creates link with a vanity string" do
      fill_in_long_url
      fill_in "vanity-string", with: "google"
      click_button "shotn!"
      expect(page).to have_selector("a", "#{current_url}google")
    end

    scenario "provides a short vanity-string" do
      fill_in_long_url
      fill_in "vanity-string", with: "goo"
      expect(page).to have_content("Your custom url is too short.")
    end

    scenario "clicks 'Shotlinks' link" do
      visit "/"
      click_link "Shotlinks"
      expect(
        page
      ).to have_content("My Shotlinks")
    end

    scenario "clicks 'My Shotlinks' tab" do
      create(:link, user: User.first)
      click_link "Shotlinks"
      click_link "My Shotlinks"
      expect(page).to have_selector("a", "#{current_url}facebook")
    end

    scenario "clicks edit icon" do
      create(:link, user: User.first)
      click_link "Shotlinks"
      click_link "My Shotlinks"
      find(".fa-pencil-square-o").click
      expect(page).to have_content("Edit Shotlink")
    end

    scenario "updates link" do
      create(:link, user: User.first)
      click_link "Shotlinks"
      click_link "My Shotlinks"
      find(".fa-pencil-square-o").click
      fill_in "link_actual", with: "https://www.google.com/"
      fill_in "vanity-string", with: "google"
      click_button "Update"
      expect(page).to have_selector("a", "#{current_url}google")
      expect(Link.first.actual).to eq "https://www.google.com/"
    end

    scenario "deactivates link" do
      create(:link, user: User.first)
      click_link "Shotlinks"
      click_link "My Shotlinks"
      find(".fa-pencil-square-o").click
      find("#link_active").set(false)
      click_button "Update"
      expect(page).to have_content("inactive")
    end

    scenario "deletes link" do
      link = create(:link, user: User.first)
      click_link "Shotlinks"
      click_link "My Shotlinks"
      find(".fa-trash-o").click
      expect(page).not_to have_content(link.actual)
    end
  end

  def fill_in_long_url
    visit root_path
    fill_in "link_actual", with: "https://www.google.com/"
  end
end
