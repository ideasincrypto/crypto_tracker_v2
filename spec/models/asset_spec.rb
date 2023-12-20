require "rails_helper"

RSpec.describe Asset, type: :model do
  describe ".new" do
    it "creates an Asset object with a Coin and an amount value" do
      coin = Coin.create!(name: "Coin", api_id: "coin", ticker: "COIN", rate: 1)
      asset = Asset.new(coin: coin, amount: 10, account: nil)

      expect(asset.coin).to eq coin
      expect(asset.amount).to eq 10
    end
  end

  describe "#value" do
    it "returns the value of the asset" do
      coin = Coin.create!(name: "Coin", api_id: "coin", ticker: "COIN", rate: 5)
      asset = Asset.new(coin: coin, amount: 10, account: nil)

      expect(asset.value).to eq 50.0
    end
  end

  describe "#percentage" do
    it "returns the percentage of the account's total value that it represents" do
      coin_a = Coin.create!(name: "Coin A", api_id: "coin_a", ticker: "CNA", rate: 10)
      coin_b = Coin.create!(name: "Coin B", api_id: "coin_b", ticker: "CNB", rate: 20)
      user = User.create!(email: "user@email.com", password: "123456")
      portfolio = Portfolio.create!(account: user.account, name: "Test Portfolio")
      portfolio.holdings.create([{ coin: coin_a, amount: 4 },
                                 { coin: coin_b, amount: 3 }])
      asset = Asset.new(coin: coin_a, amount: 4, account: user.account)

      expect(asset.percentage).to eq 40.0
    end
  end
end
