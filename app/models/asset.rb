class Asset
  attr_accessor :coin, :amount

  def initialize(coin:, amount:)
    @coin = coin
    @amount = amount
  end
end
