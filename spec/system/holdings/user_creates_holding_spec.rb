require "rails_helper"

describe "User visits the new holding page" do
  it "from the home page" do
    btc = Coin.create!(name: "Bitcoin", api_id: "bitcoin", ticker: "BTC")
    eth = Coin.create!(name: "Ethereum", api_id: "ethereum", ticker: "ETH")
    ada = Coin.create!(name: "Cardano", api_id: "cardano", ticker: "ADA")

    visit root_path
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

    visit new_holding_path
    select "BTC", from: "holding_coin_id"
    fill_in "Amount", with: 0.5
    click_on "Add"

    expect(current_path).to eq root_path
    expect(Holding.all.count).to eq 1
    expect(page).to have_content "BTC added to Portfolio"
    within "tbody" do
      expect(page).to have_content "BTC"
      expect(page).to have_content 0.5
    end
  end

  it "and can't add a coin that's already in the portfolio" do
    btc = Coin.create!(name: "Bitcoin", api_id: "bitcoin", ticker: "BTC")
    holding = Holding.create!(coin: btc, amount: 1)

    visit new_holding_path
    select "BTC", from: "holding_coin_id"
    fill_in "Amount", with: 0.2
    click_on "Add"

    expect(Holding.all.count).to eq 1
    expect(page).to have_content "BTC is already in yout portfolio. To add funds select the Deposit option."
  end
end
