require "rails_helper"

describe "Admin visits supported coins list" do
  it "and views the coins information" do
    Coin.create!(
      name: "Bitcoin",
      api_id: "bitcoin",
      ticker: "BTC"
    )
    Coin.create!(
      name: "Disabled Coin",
      api_id: "disabled_coin",
      ticker: "DSBL",
      enabled: false
    )


    visit coins_path

    expect(page).to have_content "Supported Coins"
    expect(page).to have_content "Coin: Bitcoin"
    expect(page).to have_content "API ID: bitcoin"
    expect(page).to have_content "Ticker: BTC"
    expect(page).to have_content "Status: enabled"
    expect(page).to have_button "DISABLE"
    expect(page).not_to have_content "Disabled Coin"
    expect(page).not_to have_content "disabled_coin"
    expect(page).not_to have_content "DSBL"
  end
end
