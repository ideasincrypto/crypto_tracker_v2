require "rails_helper"

describe "User visits portfolio" do
  it "and sees the holdings" do
    btc = Coin.create!(name: "Bitcoin", api_id: "bitcoin", ticker: "BTC")
    eth = Coin.create!(name: "Ethereum", api_id: "ethereum", ticker: "ETH")
    ada = Coin.create!(name: "Cardano", api_id: "cardano", ticker: "ADA")
    user = User.create!(email: "user@email.com", password: "123456")
    portfolio = Portfolio.create!(account: user.account, name: "Test Portfolio")
    portfolio.holdings.create!([
      { coin: btc, amount:0.5 },
      { coin: eth, amount: 2 },
      { coin: ada, amount: 100 }
    ])
    conn = ApiConnectionService.build
    json_contract = File.read(Rails.root.join("spec/support/json/rates_contract.json"))
    fake_response = double("res", status: 200, body: json_contract)

    login_as user, scope: :user
    allow(ApiConnectionService).to receive(:build).and_return(conn)
    allow(conn).to receive(:get).with("api/v3/simple/price").and_return(fake_response)
    visit portfolio_path(portfolio)

    within "table" do
      expect(page).to have_content "BTC"
      expect(page).to have_content 0.5
      expect(page).to have_content 43841.49
      expect(page).to have_content 21920.75
      expect(page).to have_content "ETH"
      expect(page).to have_content 2
      expect(page).to have_content 4689.48
      expect(page).to have_content "ADA"
      expect(page).to have_content 100
      expect(page).to have_content 59.00
    end
  end
end
