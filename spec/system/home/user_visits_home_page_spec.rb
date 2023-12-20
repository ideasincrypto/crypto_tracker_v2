require "rails_helper"

describe "User visits the home page", js: true do
  context "not authenticated" do
    it "and views the app info page" do
      visit root_path

      expect(current_path).to eq visitors_path
      within "nav" do
        expect(page).to have_content "CryptoTracker"
        expect(page).to have_link "Log in"
      end
      expect(page).to have_link "Create your account"
    end
  end

  context "authenticated" do
    it "and views the portfolios list and the first portfolio details" do
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
      portfolio_1 = Portfolio.create!(account: user.account, name: "First Portfolio")
      portfolio_1.holdings.create!([{ coin: btc, amount: 1 },
                                    { coin: eth, amount: 10 },
                                    { coin: ada, amount: 100 }])
      portfolio_2 = Portfolio.create!(account: user.account, name: "Second Portfolio")
      portfolio_2.holdings.create!([{ coin: btc, amount: 6 },
                                    { coin: eth, amount: 60 },
                                    { coin: ada, amount: 600 }])
      conn = ApiConnectionService.build
      request_service = ApiRequestsService.new(conn)
      json_contract = File.read(Rails.root.join("spec/support/json/rates_contract.json"))
      fake_response = double("res", status: 200, body: json_contract)

      login_as user, scope: :user
      allow(ApiConnectionService).to receive(:build).and_return(conn)
      allow(conn).to receive(:get).with("api/v3/simple/price").and_return(fake_response)
      visit root_path
      click_on "First Portfolio"

      expect(current_path).to eq root_path
      expect(page).to have_link "First Portfolio"
      expect(page).to have_link "Second Portfolio"
      expect(page).to have_selector "#new_portfolio_button"
      expect(page).to have_content "BTC"
      expect(page).to have_content "ETH"
      expect(page).to have_content "ADA"
      expect(page).to have_content 1.0
      expect(page).to have_content 10.0
      expect(page).to have_content 100.0
      expect(page).not_to have_content 7.0
      expect(page).not_to have_content 70.0
      expect(page).not_to have_content 700.0
      expect(page).to have_link "Manage", count: 3
      expect(page).to have_content "$67,347.89"
      expect(page).to have_content "$134,695.78"
    end
  end
end
