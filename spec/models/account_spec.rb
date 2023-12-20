require "rails_helper"

RSpec.describe Account, type: :model do
  describe "#net_worth" do
    it "calculates total net worth from account" do
      coin_a = Coin.create!(name: "Coin A", api_id: "coin_a", ticker: "CNA", rate: 10)
      coin_b = Coin.create!(name: "Coin B", api_id: "coin_b", ticker: "CNB", rate: 20)
      coin_c = Coin.create!(name: "Coin C", api_id: "coin_c", ticker: "CNC", rate: 30)
      user = User.create!(email: "user@email.com", password: "123456")
      portfolio_1 = Portfolio.create!(account: user.account, name: "Portoflio 1")
      portfolio_1.holdings.create([{ coin: coin_a, amount: 2 },
                                   { coin: coin_b, amount: 3 }])
      portfolio_2 = Portfolio.create!(account: user.account, name: "Portfolio 2")
      portfolio_2.holdings.create([{ coin: coin_a, amount: 5 },
                                   { coin: coin_b, amount: 4 },
                                   { coin: coin_c, amount: 1 }])
      portfolio_3 = Portfolio.create!(account: user.account, name: "Portfolio 3")
      portfolio_3.holdings.create([{ coin: coin_b, amount: 2 },
                                   { coin: coin_c, amount: 5 }])

      expect(user.account.net_worth).to eq 430.0
    end

    it "returns zero if there are no portfolios" do
      user = User.create!(email: "user@email.com", password: "123456")

      expect(user.account.net_worth).to eq 0.0
    end
  end

  describe "#assets" do
    it "returns a hash with all aggregated assets" do
      coin_a = Coin.create!(name: "Coin A", api_id: "coin_a", ticker: "CNA", rate: 1)
      coin_b = Coin.create!(name: "Coin B", api_id: "coin_b", ticker: "CNB", rate: 2)
      coin_c = Coin.create!(name: "Coin C", api_id: "coin_c", ticker: "CNC", rate: 3)
      user = User.create!(email: "user@email.com", password: "123456")
      portfolio_1 = Portfolio.create!(account: user.account, name: "Portfolio 1")
      portfolio_2 = Portfolio.create!(account: user.account, name: "Portfolio 2")
      portfolio_1.holdings.create([{ coin: coin_a, amount: 10 },
                                   { coin: coin_b, amount: 5 }])
      portfolio_2.holdings.create([{ coin: coin_b, amount: 1 },
                                   { coin: coin_c, amount: 4 }])
      assets = user.account.assets

      expect(assets.count).to eq 3
      expect(assets).to include coin_a
      expect(assets).to include coin_b
      expect(assets).to include coin_c
      expect(assets[coin_a]).to eq 10
      expect(assets[coin_b]).to eq 6
      expect(assets[coin_c]).to eq 4
    end

    it "returns an empty hash if there are no portfolios" do
      user = User.create!(email: "user@email.com", password: "123456")

      expect(user.account.assets).to be_a Hash
      expect(user.account.assets).to be_empty
    end

    it "returns an empty hash if there are no holdings" do
      user = User.create!(email: "user@email.com", password: "123456")
      Portfolio.create!(account: user.account, name: "Test Portfolio")

      expect(user.account.assets).to be_a Hash
      expect(user.account.assets).to be_empty
    end
  end
end
