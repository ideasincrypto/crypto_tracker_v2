class Account < ApplicationRecord
  belongs_to :user

  before_validation :generate_uuid

  private

  def generate_uuid
    self.uuid = SecureRandom.uuid
  end
end
