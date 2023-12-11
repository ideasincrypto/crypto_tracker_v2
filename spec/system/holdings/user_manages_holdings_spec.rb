require "rails_helper"

describe "User opens the manage options window" do
  it "from the home page" do
    btc = Coin.create!(name: "Bitcoin", api_id: "bitcoin", ticker: "BTC")
    user = User.create!(email: "user@email.com", password: "123456")
    portfolio = Portfolio.create!(account: user.account, name: "Test Portfolio")
    holding = portfolio.holdings.create(coin: btc, amount: 0.5)
    json_contract = File.read(Rails.root.join("spec/support/json/btc_rate_contract.json"))
    fake_response = double("res", status: 200, body: json_contract)
    conn = ApiConnectionService.build

    login_as user, scope: :user
    visit root_path
    allow(ApiConnectionService).to receive(:build).and_return(conn)
    allow(conn).to receive(:get).with("api/v3/simple/price").and_return(fake_response)
    click_on "Test Portfolio"

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
    json_contract = File.read(Rails.root.join("spec/support/json/btc_rate_contract.json"))
    fake_response = double("res", status: 200, body: json_contract)
    conn = ApiConnectionService.build

    login_as user, scope: :user
    allow(ApiConnectionService).to receive(:build).and_return(conn)
    allow(conn).to receive(:get).with("api/v3/simple/price").and_return(fake_response)
    visit portfolio_path(portfolio)
    find("#operation_deposit").click
    select "BTC", from: "coin_id"
    fill_in "amount", with: 1
    allow(ApiConnectionService).to receive(:build).and_return(conn)
    allow(conn).to receive(:get).with("api/v3/simple/price").and_return(fake_response)
    click_on "Confirm"

    holding.reload

    expect(page).to have_content "Successfully deposited 1.0 BTC"
    expect(holding.amount).to eq 1.5
    expect(page).to have_content "1.5"
  end

  it "and can't deposit with negative amount" do
    coin = Coin.create!(name: "Bitcoin", api_id: "bitcoin", ticker: "BTC")
    user = User.create!(email: "user@email.com", password: "123456")
    portfolio = Portfolio.create!(account: user.account, name: "Test Portfolio")
    holding = portfolio.holdings.create!(coin: coin, amount: 0.5)
    json_contract = File.read(Rails.root.join("spec/support/json/btc_rate_contract.json"))
    fake_response = double("res", status: 200, body: json_contract)
    conn = ApiConnectionService.build

    login_as user, scope: :user
    allow(ApiConnectionService).to receive(:build).and_return(conn)
    allow(conn).to receive(:get).with("api/v3/simple/price").and_return(fake_response)
    visit portfolio_path(portfolio)
    find("#operation_deposit").click
    select "BTC", from: "coin_id"
    fill_in "amount", with: -3
    allow(ApiConnectionService).to receive(:build).and_return(conn)
    allow(conn).to receive(:get).with("api/v3/simple/price").and_return(fake_response)
    click_on "Confirm"

    expect(page).to have_content "Amount must be positive"
    expect(holding.amount).to eq 0.5
  end

  it "and withdraws funds from portfolio" do
    coin = Coin.create!(name: "Bitcoin", api_id: "bitcoin", ticker: "BTC")
    user = User.create!(email: "user@email.com", password: "123456")
    portfolio = Portfolio.create!(account: user.account, name: "Test Portfolio")
    holding = portfolio.holdings.create!(coin: coin, amount: 0.5)
    json_contract = File.read(Rails.root.join("spec/support/json/btc_rate_contract.json"))
    fake_response = double("res", status: 200, body: json_contract)
    conn = ApiConnectionService.build

    login_as user, scope: :user
    allow(ApiConnectionService).to receive(:build).and_return(conn)
    allow(conn).to receive(:get).with("api/v3/simple/price").and_return(fake_response)
    visit portfolio_path(portfolio)
    find("#operation_withdraw").click
    select "BTC", from: "coin_id"
    fill_in "amount", with: 0.2
    allow(ApiConnectionService).to receive(:build).and_return(conn)
    allow(conn).to receive(:get).with("api/v3/simple/price").and_return(fake_response)
    click_on "Confirm"

    holding.reload

    expect(page).to have_content "Successfully withdrew 0.2 BTC"
    expect(page).to have_content "0.3"
    expect(holding.amount).to eq 0.3
  end

  it "and can't withdraw more than the holdings total" do
    coin = Coin.create!(name: "Bitcoin", api_id: "bitcoin", ticker: "BTC")
    user = User.create!(email: "user@email.com", password: "123456")
    portfolio = Portfolio.create!(account: user.account, name: "Test Portfolio")
    holding = portfolio.holdings.create!(coin: coin, amount: 0.5)
    json_contract = File.read(Rails.root.join("spec/support/json/btc_rate_contract.json"))
    fake_response = double("res", status: 200, body: json_contract)
    conn = ApiConnectionService.build

    login_as user, scope: :user
    allow(ApiConnectionService).to receive(:build).and_return(conn)
    allow(conn).to receive(:get).with("api/v3/simple/price").and_return(fake_response)
    visit portfolio_path(portfolio)
    find("#operation_withdraw").click
    select "BTC", from: "coin_id"
    fill_in "amount", with: 1
    click_on "Confirm"

    expect(page).to have_content "Not enough funds to withdraw"
    expect(holding.amount).to eq 0.5
    expect(page).to have_content "0.5"
  end

  it "and updates a holding" do
    coin = Coin.create!(name: "Bitcoin", api_id: "bitcoin", ticker: "BTC")
    user = User.create!(email: "user@email.com", password: "123456")
    portfolio = Portfolio.create!(account: user.account, name: "Test Portfolio")
    holding = portfolio.holdings.create!(coin: coin, amount: 0.5)
    json_contract = File.read(Rails.root.join("spec/support/json/btc_rate_contract.json"))
    fake_response = double("res", status: 200, body: json_contract)
    conn = ApiConnectionService.build

    login_as user, scope: :user
    visit portfolio_path(portfolio)
    find("#operation_update").click
    select "BTC", from: "coin_id"
    fill_in "amount", with: "1.5"
    allow(ApiConnectionService).to receive(:build).and_return(conn)
    allow(conn).to receive(:get).with("api/v3/simple/price").and_return(fake_response)
    click_on "Confirm"

    holding.reload

    expect(page).to have_content "Updated BTC value to 1.5"
    expect(holding.amount).to eq 1.5
    expect(holding.rate).to eq 43882.07
    expect(page).to have_content "1.5"
  end

  it "and can't update a holding with negative amount" do
    coin = Coin.create!(name: "Bitcoin", api_id: "bitcoin", ticker: "BTC")
    user = User.create!(email: "user@email.com", password: "123456")
    portfolio = Portfolio.create!(account: user.account, name: "Test Portfolio")
    holding = portfolio.holdings.create!(coin: coin, amount: 0.5)
    conn = ApiConnectionService.build
    json_contract = File.read(Rails.root.join("spec/support/json/btc_rate_contract.json"))
    fake_response = double("res", status: 200, body: json_contract)

    login_as user, scope: :user
    allow(ApiConnectionService).to receive(:build).and_return(conn)
    allow(conn).to receive(:get).with("api/v3/simple/price").and_return(fake_response)
    visit portfolio_path(portfolio)
    find("#operation_update").click
    select "BTC", from: "coin_id"
    fill_in "amount", with: "-8"
    click_on "Confirm"

    expect(page).to have_content "Amount must be positive"
    expect(holding.amount).to eq 0.5
  end

  it "and deletes a holding" do
    coin = Coin.create!(name: "Bitcoin", api_id: "bitcoin", ticker: "BTC")
    user = User.create!(email: "user@email.com", password: "123456")
    portfolio = Portfolio.create!(account: user.account, name: "Test Portfolio")
    holding = portfolio.holdings.create!(coin: coin, amount: 0.5)
    json_contract = File.read(Rails.root.join("spec/support/json/btc_rate_contract.json"))
    fake_response = double("res", status: 200, body: json_contract)
    conn = ApiConnectionService.build

    login_as user, scope: :user
    allow(ApiConnectionService).to receive(:build).and_return(conn)
    allow(conn).to receive(:get).with("api/v3/simple/price").and_return(fake_response)
    visit portfolio_path(portfolio)
    within "#coins-table" do
      click_on "X"
    end

    expect(page).to have_content "BTC removed from portfolio"
    within "table" do
      expect(page).not_to have_content "BTC"
    end
    expect(Holding.all.count).to eq 0
  end
end
