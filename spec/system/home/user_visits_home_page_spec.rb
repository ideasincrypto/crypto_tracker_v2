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
    it "and views the portfolios list and the first portfolio details", driver: :selenium_chrome_headless do
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
      portfolio_2.holdings.create!([{ coin: btc, amount: 2 },
                                    { coin: eth, amount: 20 },
                                    { coin: ada, amount: 200 }])

      login_as user, scope: :user
      visit root_path
      click_on "First Portfolio"

      # debugger

      expect(current_path).to eq root_path
      expect(page).to have_link "First Portfolio"
      expect(page).to have_link "Second Portfolio"
      expect(page).to have_link "New Portfolio"
      expect(page).to have_content "BTC"
      expect(page).to have_content "ETH"
      expect(page).to have_content "ADA"
      expect(page).to have_content 1.0
      expect(page).to have_content 10.0
      expect(page).to have_content 100.0
      expect(page).not_to have_content 2.0
      expect(page).not_to have_content 20.0
      expect(page).not_to have_content 200.0
      expect(page).to have_link "Manage", count: 3
      expect(page).to have_content "$67,437.89"
      expect(page).to have_content "$134,695.78"
    end
  end
end
