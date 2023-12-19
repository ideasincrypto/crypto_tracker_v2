class Account < ApplicationRecord
  belongs_to :user
  has_many :portfolios

  before_validation :generate_uuid
  after_create do |acc|
    acc.portfolios.create({ name: "Assets" })
  end


  def net_worth
    portfolios.reduce(0.0) do |total, p|
      total += p.total_value
      total
    end
  end

  private

  def generate_uuid
    self.uuid = SecureRandom.uuid
  end
end
