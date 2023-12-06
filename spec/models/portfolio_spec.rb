require "rails_helper"

RSpec.describe Portfolio, type: :model do
  describe "#valid?" do
    it "false without name" do
      portfolio = Portfolio.new(name: "")

      expect(portfolio.valid?).to be false
      expect(portfolio.errors.include?(:name)).to be true
    end
  end
end
