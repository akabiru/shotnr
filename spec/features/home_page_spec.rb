require "rails_helper"

RSpec.feature do
  context "Anonymous user" do
    scenario "sees a welcome message" do
      visit "/"
      expect(page).to have_selector("h3", "Welcome to Url  Shotnr!")
    end

    scenario "sees a form to paste long url" do
      visit "/"
      expect(page).to have_css('input#link_actual')
    end

    scenario "can paste a long url and get a short_url" do
      fill_in_long_url
      click_button "shotn!"
      expect(page).to have_selector("p", "https://www.google.com/")
    end

    scenario "can see a link to shotlinks" do
      visit "/"
      expect(page).to have_selector("a", "Shotlinks")
    end

    scenario "redirected to shotlinks page on clicking 'shotlinks'" do
      visit "/"
      click_link "Shotlinks"
      expect(
        page
      ).to have_content("Popular Recent  Top Users")
    end

    scenario "can see own short url in 'Recent Shotlinks' tab" do
      fill_in_long_url
      click_button "shotn!"
      click_link "Shotlinks"
      click_link "Recent"
      expect(page).to have_content("https://www.google.com/")
    end

    scenario "can see link to log in" do
      visit "/"
      expect(page).to have_selector("span", "Log In")
    end
  end

  context "Logged in user" do
    before(:each) do
      login_with_twitter
    end

    scenario "can log in" do
      expect(page).to have_css("input#vanity-string")
    end

    scenario "can shorten a long url without vanity string" do
      fill_in_long_url
      click_button "shotn!"
      expect(page).to have_selector("p", "https://www.google.com/")
    end

    scenario "can shorten a long url with a vanity string" do
      fill_in_long_url
      fill_in "vanity-string", with: "google"
      click_button "shotn!"
      expect(page).to have_selector("a", "#{current_url}google")
    end

    scenario "user is notified on providing a short vanity-string" do
      fill_in_long_url
      fill_in "vanity-string", with: "goo"
      expect(page).to have_content("Your custom url is too short.")
    end

    scenario "redirected to shotlinks page on clicking 'shotlinks'" do
      visit "/"
      click_link "Shotlinks"
      expect(
        page
      ).to have_content("Popular Recent  Top Users My Shotlinks")
    end

    scenario "can see a list of own shotlink" do
      create(:link, user: User.first)
      click_link "Shotlinks"
      click_link "My Shotlinks"
      expect(page).to have_selector("a", "#{current_url}facebook")
    end

    scenario "can see form to edit own urls" do
      create(:link, user: User.first)
      click_link "Shotlinks"
      click_link "My Shotlinks"
      find(".fa-pencil-square-o").click
      expect(page).to have_content("Edit Shotlink")
    end

    scenario "can edit own urls" do
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

    scenario "can deactivate own urls" do
      create(:link, user: User.first)
      click_link "Shotlinks"
      click_link "My Shotlinks"
      find(".fa-pencil-square-o").click
      find("#link_active").set(false)
      click_button "Update"
      expect(page).to have_content("inactive")
    end

    scenario "can delete own urls" do
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
