class Holding < ApplicationRecord
  belongs_to :coin
  belongs_to :portfolio

  validates :amount, numericality: { greater_than_or_equal_to: 0 }

  validate :unique_coin

  delegate :ticker, to: :coin

  def deposit(amount)
    self.amount += amount
  end

  def withdraw(amount)
    self.amount -= amount
  end

  private

  def unique_coin
    if portfolio&.holdings&.any? { |h| h.coin.id == coin.id && h.id != self.id}
      errors.add(:coin, "#{coin.ticker} is already in your portfolio. To add funds select the Deposit option.")
    end
  end

  def valid_update_amount?(amount)
    amount.positive? && amount.is_a?(Numeric)
  end
end
