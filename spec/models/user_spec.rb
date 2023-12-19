require "rails_helper"

RSpec.describe User, type: :model do
  describe ".create" do
    it "creates an account associated with the User" do
      user = User.create!(email: "user@email.com", password: "123456")

      expect(user.account).not_to be_nil
      expect(user.account.uuid.length).to eq 36
      expect(Account.all.count).to eq 1
      expect(Account.last.user).to eq user
    end

    it "creates an account with a unique UUID code" do
      first_user = User.create!(email: "first_user@email.com", password: "123456")
      second_user = User.create!(email: "second_user@email.com", password: "123456")

      expect(first_user.account.uuid).not_to eq second_user.account.uuid
    end

    it "doesn't create account if User is not persisted" do
      invalid_user = User.create(email: "invalid.email.com", password: 123456)

      expect(invalid_user.account).to be_nil
      expect(Account.all.count).to eq 0
    end

    it "creates Assets portfolio for account" do
      user = User.create!(email: "user@email.com", password: "123456")

      expect(user.portfolios.count).to eq 1
      expect(user.portfolios.first.name).to eq "Assets"
      expect(user.portfolios.first.holdings).to be_empty
    end
  end

  describe ".update" do
    it "doesn't change the account UUID if user is updated" do
      user = User.create!(email: "user@email.com", password: "123456")
      og_uuid = user.account.uuid

      user.password = "654321"
      user.save!
      user.reload

      expect(user.account.uuid).to eq og_uuid
    end
  end
end
