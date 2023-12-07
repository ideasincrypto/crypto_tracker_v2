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

  it "and accesses the withdraw option" do
    coin = Coin.create!(name: "Bitcoin", api_id: "bitcoin", ticker: "BTC")
    user = User.create!(email: "user@email.com", password: "123456")
    portfolio = Portfolio.create!(account: user.account, name: "Test Portfolio")
    holding = portfolio.holdings.create!(coin: coin, amount: 0.5)

    login_as user, scope: :user
    visit root_path
    click_on "Test Portfolio"
    find("details#manage-options").click
    click_on "Withdraw"

    expect(page).to have_select "withdraw_coin_id", options: ["Coin", "BTC"]
    expect(page).to have_field "withdraw_amount", type: "number"
    expect(page).to have_button "Withdraw"
  end

  it "withdraws funds from portfolio" do
    coin = Coin.create!(name: "Bitcoin", api_id: "bitcoin", ticker: "BTC")
    user = User.create!(email: "user@email.com", password: "123456")
    portfolio = Portfolio.create!(account: user.account, name: "Test Portfolio")
    holding = portfolio.holdings.create!(coin: coin, amount: 0.5)

    login_as user, scope: :user
    visit new_portfolio_withdraw_path(portfolio)
    select "BTC", from: "withdraw_coin_id"
    fill_in "withdraw_amount", with: 0.2
    click_on "Withdraw"

    holding.reload

    expect(page).to have_content "Withdraw 0.2 BTC"
    expect(page).to have_content "0.3"
    expect(holding.amount).to eq 0.3
  end

  it "can't withdraw with invalid params" do
    coin = Coin.create!(name: "Bitcoin", api_id: "bitcoin", ticker: "BTC")
    user = User.create!(email: "user@email.com", password: "123456")
    portfolio = Portfolio.create!(account: user.account, name: "Test Portfolio")
    holding = portfolio.holdings.create!(coin: coin, amount: 0.5)

    login_as user, scope: :user
    visit new_portfolio_withdraw_path(portfolio)
    select "BTC", from: "withdraw_coin_id"
    fill_in "withdraw_amount", with: 1
    click_on "Withdraw"

    expect(page).to have_content "Not enough funds to withdraw"
    expect(holding.amount).to eq 0.5
  end

  it "and accesses the update option" do
    coin = Coin.create!(name: "Bitcoin", api_id: "bitcoin", ticker: "BTC")
    user = User.create!(email: "user@email.com", password: "123456")
    portfolio = Portfolio.create!(account: user.account, name: "Test Portfolio")
    holding = portfolio.holdings.create!(coin: coin, amount: 0.5)

    login_as user, scope: :user
    visit root_path
    click_on "Test Portfolio"
    find("details#manage-options").click
    click_on "Update"

    expect(page).to have_select "update_coin_id", options: ["Coin", "BTC"]
    expect(page).to have_field "update_amount", type: "number"
    expect(page).to have_button "Update"
  end

  it "and updates a holding" do
    coin = Coin.create!(name: "Bitcoin", api_id: "bitcoin", ticker: "BTC")
    user = User.create!(email: "user@email.com", password: "123456")
    portfolio = Portfolio.create!(account: user.account, name: "Test Portfolio")
    holding = portfolio.holdings.create!(coin: coin, amount: 0.5)

    login_as user, scope: :user
    visit root_path
    click_on "Test Portfolio"
    find("details#manage-options").click
    click_on "Update"
    select "BTC", from: "update_coin_id"
    fill_in "update_amount", with: "1.5"
    click_on "Update"

    holding.reload

    expect(holding.amount).to eq 1.5
    expect(page).to have_content "1.5"
  end
end
