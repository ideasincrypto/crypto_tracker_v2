require "rails_helper"

describe "User accesses the login page" do
  it "from the home page" do
    visit root_path
    within "nav#navigation-bar" do
      click_on "Log in"
    end
    expect(current_path).to eq new_user_session_path
    expect(page).to have_field "Email"
    expect(page).to have_field "Password"
  end
  it "and logs in" do
    user = User.create!(email: "user@email.com", password: "123456")

    visit root_path
    within "nav#navigation-bar" do
      click_on "Log in"
    end
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    within "div.actions" do
      click_on "Log in"
    end

    expect(current_path).to eq root_path
    within "nav#navigation-bar" do
      expect(page).to have_content user.email
      expect(page).not_to have_link "Log in"
      expect(page).to have_button "Log out"
    end
  end
end
