class Holding < ApplicationRecord
  belongs_to :coin
  belongs_to :portfolio

  validates :amount, numericality: { greater_than_or_equal_to: 0 }

  validate :unique_coin

  delegate :ticker, to: :coin

  private

  def unique_coin
    # debugger
    if portfolio&.holdings&.any? { |h| h.coin.id == coin.id}
      errors.add(:coin, "#{coin.ticker} is already in your portfolio. To add funds select the Deposit option.")
    end
  end
end
