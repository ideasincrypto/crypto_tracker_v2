require "rails_helper"

describe "User accesses the new account page" do
  it "from the home page" do
    visit root_path
    within "nav#navigation-bar" do
      click_on "Log in"
    end
    click_on "Sign up"

    expect(page).to have_field "Email"
    expect(page).to have_field "Password"
    expect(page).to have_field "Password confirmation"
    expect(page).to have_button "Sign up"
  end

  it "and creates a new account" do
    visit root_path
    within "nav#navigation-bar" do
      click_on "Log in"
    end
    click_on "Sign up"
    fill_in "Email", with: "user@email.com"
    fill_in "Password", with: "123456"
    fill_in "Password confirmation", with: "123456"
    within "div.actions" do
      click_on "Sign up"
    end

    expect(current_path).to eq root_path
    within "nav#navigation-bar" do
      expect(page).to have_content "user@email.com"
      expect(page).to have_button "Log out"
      expect(page).not_to have_link "Log in"
    end
  end
end
