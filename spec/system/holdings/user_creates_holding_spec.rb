require "rails_helper"

describe "User visits the new holding page" do
  it "from the home page" do
    btc = Coin.create!(name: "Bitcoin", api_id: "bitcoin", ticker: "BTC")
    eth = Coin.create!(name: "Ethereum", api_id: "ethereum", ticker: "ETH")
    ada = Coin.create!(name: "Cardano", api_id: "cardano", ticker: "ADA")
    user = User.create!(email: "user@email.com", password: "123456")
    portfolio = Portfolio.create!(account: user.account, name: "Test Portfolio")
    json_contract = File.read(Rails.root.join("spec/support/json/rates_contract.json"))
    fake_response = double("res", status: 200, body: json_contract)
    conn = ApiConnectionService.build

    login_as user, scope: :user
    visit root_path
    allow(ApiConnectionService).to receive(:build).and_return(conn)
    allow(conn).to receive(:get).with("api/v3/simple/price").and_return(fake_response)
    click_on "Test Portfolio"
    find("#new_holding_button").click

    expect(page).to have_content "New Holding"
    expect(page).to have_select "holding_coin_id", options: ["Coin", "BTC", "ETH", "ADA"]
    expect(page).to have_field "Amount"
    expect(page).to have_button "Add"
    expect(page).to have_link "Back"
  end

  it "and creates a new Holding" do
    btc = Coin.create!(name: "Bitcoin",
                       api_id: "bitcoin",
                       ticker: "BTC",
                       icon: "https://assets.coingecko.com/coins/images/1/large/bitcoin.png?1696501400")
    eth = Coin.create!(name: "Ethereum",
                       api_id: "ethereum",
                       ticker: "ETH",
                       icon: "https://assets.coingecko.com/coins/images/279/large/ethereum.png?1696501628")
    ada = Coin.create!(name: "Cardano",
                       api_id: "cardano",
                       ticker: "ADA",
                       icon: "https://assets.coingecko.com/coins/images/975/large/cardano.png?1696502090")
    user = User.create!(email: "user@email.com", password: "123456")
    portfolio = Portfolio.create!(account: user.account, name: "Test Portfolio")
    json_contract = File.read(Rails.root.join("spec/support/json/btc_rate_contract.json"))
    fake_response = double("res", status: 200, body: json_contract)
    conn = ApiConnectionService.build

    login_as user, scope: :user
    visit new_portfolio_holding_path(portfolio)
    select "BTC", from: "holding_coin_id"
    fill_in "Amount", with: 0.5
    allow(ApiConnectionService).to receive(:build).and_return(conn)
    allow(conn).to receive(:get).with("api/v3/simple/price").and_return(fake_response)
    click_on "Add"

    expect(current_path).to eq portfolio_path(portfolio)
    expect(Holding.all.count).to eq 1
    expect(page).to have_content "BTC added to Portfolio"
    expect(page).not_to have_content "Your portfolio is empty. Add coins to see them here"
    expect(Holding.last.coin.rate).to eq 43882.07
    expect(page).to have_content "BTC"
    expect(page).to have_content 0.5
    expect(page).to have_content "$43,882.07"
    expect(page).to have_content "$21,941.04"
  end

  it "and can't add a coin that's already in the portfolio" do
    btc = Coin.create!(name: "Bitcoin",
                       api_id: "bitcoin",
                       ticker: "BTC",
                       icon: "https://assets.coingecko.com/coins/images/1/large/bitcoin.png?1696501400")
    user = User.create!(email: "user@email.com", password: "123456")
    portfolio = Portfolio.create!(account: user.account, name: "Test Portfolio")
    holding = Holding.create!(portfolio: portfolio, coin: btc, amount: 1)
    json_contract = File.read(Rails.root.join("spec/support/json/rates_contract.json"))
    fake_response = double("res", status: 200, body: json_contract)
    conn = ApiConnectionService.build

    login_as user, scope: :user
    visit new_portfolio_holding_path(portfolio)
    select "BTC", from: "holding_coin_id"
    fill_in "Amount", with: 0.2
    click_on "Add"
    allow(ApiConnectionService).to receive(:build).and_return(conn)
    allow(conn).to receive(:get).with("api/v3/simple/price").and_return(fake_response)

    expect(Holding.all.count).to eq 1
    expect(page).to have_content "BTC is already in your portfolio. To add funds select the Deposit option."
  end
end
