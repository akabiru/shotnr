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
      click_link "Shotlinks"
      click_link "Recent"
      expect(page).to have_content("https://www.google.com/")
    end

    scenario "can see link to log in" do
      visit "/"
      expect(page).to have_selector("span", "Log In")
    end
  end

  def fill_in_long_url
    visit root_path
    fill_in "link_actual", with: "https://www.google.com/"
    click_button "shotn!"
  end
end
