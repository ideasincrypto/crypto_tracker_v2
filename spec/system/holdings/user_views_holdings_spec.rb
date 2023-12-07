require "rails_helper"

describe "User visits portfolio" do
  it "and sees the holdings" do
    btc = Coin.create!(name: "Bitcoin", api_id: "bitcoin", ticker: "BTC")
    eth = Coin.create!(name: "Ethereum", api_id: "ethereum", ticker: "ETH")
    user = User.create!(email: "user@email.com", password: "123456")
    portfolio = Portfolio.create!(account: user.account, name: "Test Portfolio")
    btc_holding = portfolio.holdings.create!(coin: btc, amount: 0.5)
    eth_holding = portfolio.holdings.create!(coin: eth, amount: 2)

    login_as user, scope: :user
    visit portfolio_path(portfolio)

    expect(page).to have_content "BTC"
    expect(page).to have_content 0.5
    expect(page).to have_content "ETH"
    expect(page).to have_content 2
  end
end
