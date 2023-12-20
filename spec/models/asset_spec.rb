require "rails_helper"

RSpec.describe Asset, type: :model do
  describe ".new" do
    it "creates an Asset object with a Coin and an amount value" do
      coin = Coin.create!(name: "Coin", api_id: "coin", ticker: "COIN", rate: 1)
      asset = Asset.new(coin: coin, amount: 10)

      expect(asset.coin).to eq coin
      expect(asset.amount).to eq 10
    end
  end
end
