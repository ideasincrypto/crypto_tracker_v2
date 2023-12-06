require "rails_helper"

describe "User opens the manage options window" do
  it "from the home page" do
    coin = Coin.create!(name: "Bitcoin", api_id: "bitcoin", ticker: "BTC")
    user = User.create!(email: "user@email.com", password: "123456")
    portfolio = Portfolio.create!(account: user.account, name: "Test Portfolio")

    login_as user, scope: :user
    visit root_path
    click_on "Test Portfolio"
    find("details#manage-options").click

    expect(page).to have_link "Deposit"
    expect(page).to have_link "Withdraw"
    expect(page).to have_link "Update"
  end

  it "and accesses the Deposit option" do
    coin = Coin.create!(name: "Bitcoin", api_id: "bitcoin", ticker: "BTC")
    user = User.create!(email: "user@email.com", password: "123456")
    portfolio = Portfolio.create!(account: user.account, name: "Test Portfolio")
    holding = portfolio.holdings.create!(coin: coin, amount: 0.5)

    login_as user, scope: :user
    visit root_path
    click_on "Test Portfolio"
    find("details#manage-options").click
    click_on "Deposit"

    # expect(page).to have_select "Coin", options: ["Coin", "BTC"]
    # expect(page).to have_field, "Amount"
    # expect(page).to have_button "Deposit"
  end
end
