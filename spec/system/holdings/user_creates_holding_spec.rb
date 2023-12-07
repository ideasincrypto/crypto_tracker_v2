require "rails_helper"

describe "User visits the new holding page" do
  it "from the home page" do
    btc = Coin.create!(name: "Bitcoin", api_id: "bitcoin", ticker: "BTC")
    eth = Coin.create!(name: "Ethereum", api_id: "ethereum", ticker: "ETH")
    ada = Coin.create!(name: "Cardano", api_id: "cardano", ticker: "ADA")
    user = User.create!(email: "user@email.com", password: "123456")
    portfolio = Portfolio.create!(account: user.account, name: "Test Portfolio")

    login_as user, scope: :user
    visit root_path
    click_on "Test Portfolio"
    click_on "Add new Holding"

    expect(page).to have_content "New Holding"
    expect(page).to have_select "holding_coin_id", options: ["Coin", "BTC", "ETH", "ADA"]
    expect(page).to have_field "Amount"
    expect(page).to have_button "Add"
    expect(page).to have_link "Back"
  end

  it "and creates a new Holding" do
    btc = Coin.create!(name: "Bitcoin", api_id: "bitcoin", ticker: "BTC")
    eth = Coin.create!(name: "Ethereum", api_id: "ethereum", ticker: "ETH")
    ada = Coin.create!(name: "Cardano", api_id: "cardano", ticker: "ADA")
    user = User.create!(email: "user@email.com", password: "123456")
    portfolio = Portfolio.create!(account: user.account, name: "Test Portfolio")

    login_as user
    visit new_portfolio_holding_path(portfolio)
    select "BTC", from: "holding_coin_id"
    fill_in "Amount", with: 0.5
    click_on "Add"

    expect(current_path).to eq portfolio_path(portfolio)
    expect(Holding.all.count).to eq 1
    expect(page).to have_content "BTC added to Portfolio"
    expect(page).not_to have_content "Your portfolio is empty. Add coins to see them here"
    within "tbody" do
      expect(page).to have_content "BTC"
      expect(page).to have_content 0.5
    end
  end

  it "and can't add a coin that's already in the portfolio" do
    btc = Coin.create!(name: "Bitcoin", api_id: "bitcoin", ticker: "BTC")
    user = User.create!(email: "user@email.com", password: "123456")
    portfolio = Portfolio.create!(account: user.account, name: "Test Portfolio")
    holding = Holding.create!(portfolio: portfolio, coin: btc, amount: 1)

    login_as user, scope: :user
    visit new_portfolio_holding_path(portfolio)
    select "BTC", from: "holding_coin_id"
    fill_in "Amount", with: 0.2
    click_on "Add"

    expect(Holding.all.count).to eq 1
    expect(page).to have_content "BTC is already in your portfolio. To add funds select the Deposit option."
  end
end