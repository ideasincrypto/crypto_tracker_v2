require "rails_helper"

describe "User opens the manage options window" do
  it "from the home page" do
    coin = Coin.create!(name: "Bitcoin", api_id: "bitcoin", ticker: "BTC")
    user = User.create!(email: "user@email.com", password: "123456")
    portfolio = Portfolio.create!(account: user.account, name: "Test Portfolio")

    login_as user, scope: :user
    visit root_path
    click_on "Test Portfolio"
    find("details#manage-options").click

    expect(page).to have_link "Deposit"
    expect(page).to have_link "Withdraw"
    expect(page).to have_link "Update"
  end

  it "and accesses the Deposit option" do
    coin = Coin.create!(name: "Bitcoin", api_id: "bitcoin", ticker: "BTC")
    user = User.create!(email: "user@email.com", password: "123456")
    portfolio = Portfolio.create!(account: user.account, name: "Test Portfolio")
    holding = portfolio.holdings.create!(coin: coin, amount: 0.5)

    login_as user, scope: :user
    visit root_path
    click_on "Test Portfolio"
    find("details#manage-options").click
    click_on "Deposit"

    expect(page).to have_select "deposit_coin_id", options: ["Coin", "BTC"]
    expect(page).to have_field, "amount"
    expect(page).to have_button "Deposit"
  end

  it "and deposits funds to portfolio" do
    coin = Coin.create!(name: "Bitcoin", api_id: "bitcoin", ticker: "BTC")
    user = User.create!(email: "user@email.com", password: "123456")
    portfolio = Portfolio.create!(account: user.account, name: "Test Portfolio")
    holding = portfolio.holdings.create!(coin: coin, amount: 0.5)

    login_as user, scope: :user
    visit portfolio_path(portfolio)
    find("details#manage-options").click
    click_on "Deposit"
    select "BTC", from: "deposit_coin_id"
    fill_in "deposit_amount", with: 1
    click_on "Deposit"

    holding.reload

    expect(page).to have_content "Successfully deposited 1.0 BTC"
    expect(holding.amount).to eq 1.5
    expect(page).to have_content "1.5"
  end

  it "and can't deposit with invalid params" do
    coin = Coin.create!(name: "Bitcoin", api_id: "bitcoin", ticker: "BTC")
    user = User.create!(email: "user@email.com", password: "123456")
    portfolio = Portfolio.create!(account: user.account, name: "Test Portfolio")
    holding = portfolio.holdings.create!(coin: coin, amount: 0.5)

    login_as user, scope: :user
    visit portfolio_path(portfolio)
    find("details#manage-options").click
    click_on "Deposit"
    select "BTC", from: "deposit_coin_id"
    fill_in "deposit_amount", with: -3
    click_on "Deposit"

    expect(page).to have_content "Amount must be a positive number"
    expect(holding.amount).to eq 0.5
  end
end
