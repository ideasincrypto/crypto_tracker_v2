require "rails_helper"

RSpec.describe ApiConnectionService, type: :model do
  describe ".build" do
    it "returns a Faraday connection object to the Coin Gecko API" do
      conn = ApiConnectionService.build

      expect(conn).to be_a(Faraday::Connection)
      expect(conn.url_prefix.to_s).to eq "https://api.coingecko.com/"
    end
  end
end
