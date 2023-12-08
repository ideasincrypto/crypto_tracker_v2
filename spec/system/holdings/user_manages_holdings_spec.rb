require "rails_helper"

describe "User opens the manage options window" do
  it "from the home page" do
    btc = Coin.create!(name: "Bitcoin", api_id: "bitcoin", ticker: "BTC")
    user = User.create!(email: "user@email.com", password: "123456")
    portfolio = Portfolio.create!(account: user.account, name: "Test Portfolio")
    holding = portfolio.holdings.create(coin: btc, amount: 0.5)

    login_as user, scope: :user
    visit root_path
    click_on "Test Portfolio"
    find("details#manage-options").click

    expect(page).to have_selector "#operation_deposit"
    expect(page).to have_selector "#operation_withdraw"
    expect(page).to have_selector "#operation_update"
    expect(page).to have_select "coin_id", options: ["Coin", "BTC"]
    expect(page).to have_field "amount", type: "number"
    expect(page).to have_button "Confirm"
  end

  it "and deposits funds to portfolio" do
    coin = Coin.create!(name: "Bitcoin", api_id: "bitcoin", ticker: "BTC")
    user = User.create!(email: "user@email.com", password: "123456")
    portfolio = Portfolio.create!(account: user.account, name: "Test Portfolio")
    holding = portfolio.holdings.create!(coin: coin, amount: 0.5)

    login_as user, scope: :user
    visit portfolio_path(portfolio)
    find("details#manage-options").click
    find("#operation_deposit").click
    select "BTC", from: "coin_id"
    fill_in "amount", with: 1
    click_on "Confirm"

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
    find("#operation_deposit").click
    select "BTC", from: "coin_id"
    fill_in "amount", with: -3
    click_on "Confirm"

    expect(page).to have_content "Amount must be positive"
    expect(holding.amount).to eq 0.5
  end

  it "and withdraws funds from portfolio" do
    coin = Coin.create!(name: "Bitcoin", api_id: "bitcoin", ticker: "BTC")
    user = User.create!(email: "user@email.com", password: "123456")
    portfolio = Portfolio.create!(account: user.account, name: "Test Portfolio")
    holding = portfolio.holdings.create!(coin: coin, amount: 0.5)

    login_as user, scope: :user
    visit portfolio_path(portfolio)
    find("#manage-options").click
    find("#operation_withdraw").click
    select "BTC", from: "coin_id"
    fill_in "amount", with: 0.2
    click_on "Confirm"

    holding.reload

    expect(page).to have_content "Successfully withdrew 0.2 BTC"
    expect(page).to have_content "0.3"
    expect(holding.amount).to eq 0.3
  end

  it "can't withdraw with invalid params" do
    coin = Coin.create!(name: "Bitcoin", api_id: "bitcoin", ticker: "BTC")
    user = User.create!(email: "user@email.com", password: "123456")
    portfolio = Portfolio.create!(account: user.account, name: "Test Portfolio")
    holding = portfolio.holdings.create!(coin: coin, amount: 0.5)

    login_as user, scope: :user
    visit portfolio_path(portfolio)
    find("#manage-options").click
    find("#operation_withdraw").click
    select "BTC", from: "coin_id"
    fill_in "amount", with: 1
    click_on "Confirm"

    expect(page).to have_content "Not enough funds to withdraw"
    expect(holding.amount).to eq 0.5
    expect(page).to have_content "0.5"
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
