class Account < ApplicationRecord
  belongs_to :user
  has_many :portfolios
  has_many :holdings, through: :portfolios

  before_validation :generate_uuid

  def net_worth
    portfolios.reduce(0.0) do |total, p|
      total += p.total_value
      total
    end
  end

  def assets
    holdings.group(:coin).sum(:amount)
  end

  private

  def generate_uuid
    self.uuid = SecureRandom.uuid
  end
end
