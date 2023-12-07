require "rails_helper"

describe "User visits the home page" do
  context "not authenticated" do
    it "and see the nav bar" do
      visit root_path

      within "nav" do
        expect(page).to have_content "CryptoTracker"
        expect(page).to have_link "Log in"
      end
    end
  end

  context "authenticated" do
    it "and views the table" do
      user = User.create!(email: "user@email.com", password: "123456")

      login_as user, scope: :user
      visit root_path

      # expect(page).to have_selector "table"
      # within("table") do
      #   expect(page).to have_selector "thead"
      #   within("thead") do
      #     expect(page).to have_selector "th", text: "Coin"
      #     expect(page).to have_selector "th", text: "Amount"
      #     expect(page).to have_selector "th", text: "Rate (USD)"
      #     expect(page).to have_selector "th", text: "24h change"
      #     expect(page).to have_selector "th", text: "Value"
      #     expect(page).to have_selector "th", text: "%"
      #   end
      #   expect(page).to have_selector "tbody"
      #   expect(page).to have_selector "tfoot"
      #   within("tfoot") do
      #     expect(page).to have_selector "td", text: "TOTAL"
      #   end
      # end
    end
  end
end
