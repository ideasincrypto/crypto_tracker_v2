require "rails_helper"

describe "User visits the home page" do
  context "not authenticated" do
    it "and see the nav bar" do
      visit root_path

      expect(page).to have_content "CryptoTracker"
    end
  end
end
