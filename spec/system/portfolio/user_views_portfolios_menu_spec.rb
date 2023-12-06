require "rails_helper"

describe "User views the Portfolios menu" do
  it "from the home page" do
    user = User.create!(email: "user@email.com", password: "123456")
    portfolio_1 = Portfolio.create!(account: user.account, name: "Portfolio 1")
    portfolio_2 = Portfolio.create!(account: user.account, name: "Portfolio 2")
    portfolio_3 = Portfolio.create!(account: user.account, name: "Portfolio 3")

    login_as user, scope: :user
    visit root_path

    expect(page).to have_selector "#portfolios-menu"
    within "#portfolios-menu" do
      expect(page).to have_button "New Portfolio"
      expect(page).to have_content "Portfolios"
      expect(page).to have_link "Portfolio 1"
      expect(page).to have_link "Portfolio 2"
      expect(page).to have_link "Portfolio 3"
    end
  end

  it "and accesses a portfolio" do
    user = User.create!(email: "user@email.com", password: "123456")
    portfolio_1 = Portfolio.create!(account: user.account, name: "Portfolio 1")
    portfolio_2 = Portfolio.create!(account: user.account, name: "Portfolio 2")
    portfolio_3 = Portfolio.create!(account: user.account, name: "Portfolio 3")

    login_as user, scope: :user
    visit root_path
    within "#portfolios-menu" do
      click_on "Portfolio 1"
    end

    expect(current_path).to eq portfolio_path(portfolio_1)
    expect(page).to have_content "Portfolio 1"
    expect(page).to have_content "Your portfolio is empty. Add coins to see them here"
  end
end
