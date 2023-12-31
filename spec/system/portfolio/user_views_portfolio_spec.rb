require "rails_helper"

describe "User visits the portfolio page" do
  it "and views the portfolio's holdings and total value'" do
    conn = ApiConnectionService.build
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
    portfolio.holdings.create([{ coin: btc, amount: 1 },
                               { coin: eth, amount: 2 },
                               { coin: ada, amount: 100 }])
    json_contract = File.read(Rails.root.join("spec/support/json/rates_contract.json"))
    fake_response = double("res", status: 200, body: json_contract)

    login_as user, scope: :user
    visit root_path
    allow(ApiConnectionService).to receive(:build).and_return(conn)
    allow(conn).to receive(:get).with("api/v3/simple/price").and_return(fake_response)
    click_on "Test Portfolio"

    expect(page).to have_content "Test Portfolio"
    expect(page).to have_content "Asset"
    expect(page).to have_content "Balance"
    expect(page).to have_css "a", text: "Manage", exact_text: true, count: 3
    expect(page).to have_selector "img[src='https://assets.coingecko.com/coins/images/1/large/bitcoin.png?1696501400']"
    expect(page).to have_content "BTC"
    expect(page).to have_content "1.0"
    expect(page).to have_content "$43,841.49", count: 2
    expect(page).to have_selector "img[src='https://assets.coingecko.com/coins/images/279/large/ethereum.png?1696501628']"
    expect(page).to have_content "ETH"
    expect(page).to have_content "2.0"
    expect(page).to have_content "$2,344.74"
    expect(page).to have_content "$4,689.48"
    expect(page).to have_selector "img[src='https://assets.coingecko.com/coins/images/975/large/cardano.png?1696502090']"
    expect(page).to have_content "ADA"
    expect(page).to have_content "100.0"
    expect(page).to have_content "$0.59"
    expect(page).to have_content "$59.00"
    expect(page).to have_content "$48,589.97"
  end
end
