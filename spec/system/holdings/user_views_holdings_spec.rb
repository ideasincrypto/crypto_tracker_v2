require "rails_helper"

describe "User visits home page" do
  it "and sees the holdings in table" do
    btc = Coin.create!(name: "Bitcoin", api_id: "bitcoin", ticker: "BTC")
    btc_holding = Holding.create!(coin: btc, amount: 0.5)
    eth = Coin.create!(name: "Ethereum", api_id: "ethereum", ticker: "ETH")
    eth_holding = Holding.create!(coin: eth, amount: 2)

    visit root_path

    expect(page).to have_content "BTC"
    expect(page).to have_content 0.5
    expect(page).to have_content "ETH"
    expect(page).to have_content 2
  end
end
