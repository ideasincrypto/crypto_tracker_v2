require "rails_helper"

describe "User opens the manage options window" do
  it "from the home page" do
    visit root_path
    find("details#manage-options").click

    expect(page).to have_link "Deposit"
    expect(page).to have_link "Withdraw"
    expect(page).to have_link "Update"
  end

  it "and accesses the Deposit option" do
    coin = Coin.create!(name: "Bitcoin", api_id: "bitcoin", ticker: "BTC")
    holding = Holding.create!(coin: coin, amount: 0.5)

    visit root_path
    find("details#manage-options").click
    click_on "Deposit"

    expect(page).to have_select "Coin", options: ["Coin", "BTC"]
    expect(page).to have_field, "Amount"
    expect(page).to have_button "Deposit"
  end
end
