class Account < ApplicationRecord
  belongs_to :user
  has_many :portfolios

  before_validation :generate_uuid

  private

  def generate_uuid
    self.uuid = SecureRandom.uuid
  end
end
