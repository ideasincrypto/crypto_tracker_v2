require "rails_helper"

describe "User logs out" do
  it "successfully" do
    user = User.create!(email: "user@email.com", password: "123456")

    login_as user, scope: :user
    visit root_path
    within "nav#navigation-bar" do
      click_on "Log out"
    end

    expect(current_path).to eq new_user_session_path
    within "nav#navigation-bar" do
      expect(page).to have_link "Log in"
      expect(page).not_to have_button "Log out"
      expect(page).not_to have_content user.email
    end
  end
end
