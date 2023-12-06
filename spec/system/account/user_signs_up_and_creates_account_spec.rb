require "rails_helper"

describe "User signs-up" do
  it "and an account is automatically created" do
    visit new_user_registration_path
    fill_in "Email", with: "user@email.com"
    fill_in "Password", with: "123456"
    fill_in "Password confirmation", with: "123456"
    click_on "Sign up"

    expect(User.last.email).to eq "user@email.com"
    expect(Account.all).to eq 1
    expect(Account.last.uuid).not_to be_nil
    expect(Accounts.last.uuid.length).to eq 36
  end
end
