class Asset
  attr_accessor :coin, :amount, :account

  def initialize(coin:, amount:, account:)
    @coin = coin
    @amount = amount
    @account = account
  end

  def value
    @coin.rate * @amount
  end

  def percentage
    (value * 100 / @account.net_worth).round(2)
  end
end
