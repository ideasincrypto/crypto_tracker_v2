require "rails_helper"

RSpec.describe ApiRequestsService, type: :model do
  describe "#get_rates" do
    it "return a hash of rates from the API" do
      btc = Coin.new(name: "Bitcoin", api_id: "bitcoin", ticker: "BTC")
      eth = Coin.new(name: "Ethereum", api_id: "ethereum", ticker: "ETH")
      ada = Coin.new(name: "Cardano", api_id: "cardano", ticker: "ADA")
      conn = ApiConnectionService.build
      request_service = ApiRequestsService.new(conn)
      json_contract = File.read(Rails.root.join("spec/support/json/rates_contract.json"))
      fake_response = double("res", status: 200, body: json_contract)

      allow(conn).to receive(:get).and_return(fake_response)
      rates = request_service.get_rates(btc, eth, ada)

      expect(rates).to be_a Hash
      expect(rates.keys).to include :bitcoin, :ethereum, :cardano
      expect(rates[:bitcoin]).to eq usd: 43841.49
      expect(rates[:ethereum]).to eq usd: 2344.74
      expect(rates[:cardano]).to eq usd: 0.59
    end
  end
end
