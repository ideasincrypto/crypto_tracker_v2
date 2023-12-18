require "rails_helper"

describe "User visits the home page" do
  context "not authenticated" do
    it "and views the app info page" do
      visit root_path

      expect(current_path).to eq visitors_path
      within "nav" do
        expect(page).to have_content "CryptoTracker"
        expect(page).to have_link "Log in"
      end
      expect(page).to have_link "Create your account"
    end
  end

  context "authenticated" do
    it "and views the portfolios list and the first portfolio details" do
      user = User.create!(email: "user@email.com", password: "123456")

      login_as user, scope: :user
      visit root_path
    end
  end
end
