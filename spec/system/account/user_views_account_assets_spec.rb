require "rails_helper"

describe "User views account assets" do
  it "without having a portfolio" do
    user = User.create!(email: "user@email.com", password: "123456")

    login_as user, scope: :user
    visit assets_account_path

    expect(page).to have_content "You don't have any assets yet"
    expect(page).to have_link "Create a new Portfolio"
  end

  it "with an empty portfolio" do
    user = User.create!(email: "user@email.com", password: "123456")
    portoflio = Portfolio.create!(account: user.account, name: "Test Portfolio")

    login_as user, scope: :user
    visit assets_account_path

    expect(page).to have_content "You don't have any assets yet"
    expect(page).to have_content "Add assets to you portfolios to see them here"
    expect(page).not_to have_link "Create a new Portfolio"
  end

  it "and see the account's assets" do
    icon_url = "https://upload.wikimedia.org/wikipedia/commons/a/ac/No_image_available.svg"
    coin_a = Coin.create!(name: "Coin A",
                          api_id: "coin_a",
                          ticker: "CNA",
                          rate: 1,
                          icon: icon_url)
    coin_b = Coin.create!(name: "Coin B",
                          api_id: "coin_b",
                          ticker: "CNB",
                          rate: 2,
                          icon: icon_url)
    coin_c = Coin.create!(name: "Coin C",
                          api_id: "coin_c",
                          ticker: "CNC",
                          rate: 3,
                          icon: icon_url)
    user = User.create!(email: "user@email.com", password: "123456")
    portfolio_1 = Portfolio.create!(account: user.account, name: "Portfolio 1")
    portfolio_1.holdings.create([{ coin: coin_a, amount: 10 },
                                 { coin: coin_b, amount: 2 },])
    portfolio_2 = Portfolio.create!(account: user.account, name: "Portfolio 2")
    portfolio_2.holdings.create([{ coin: coin_b, amount: 4 },
                                 { coin: coin_c, amount: 8 }])

    login_as user, scope: :user
    visit assets_account_path

    expect(page).not_to have_content "You don't have any assets yet"
    expect(page).not_to have_content "Add assets to you portfolios to see them here"
    expect(page).not_to have_link "Create a new Portfolio"
    expect(page).to have_content "Account assets"
    expect(page).to have_content "Total:"
    expect(page).to have_content "$46.0"
    expect(page).to have_content "Asset"
    expect(page).to have_content "Balance"
    expect(page).to have_content "CNA"
    expect(page).to have_content "CNB"
    expect(page).to have_content "CNC"
    expect(page).to have_content "1.0"
    expect(page).to have_content "2.0"
    expect(page).to have_content "3.0"
    expect(page).to have_content "$10.0"
    expect(page).to have_content "$12.0"
    expect(page).to have_content "$24.0"
    expect(page).to have_content "21.74%"
    expect(page).to have_content "26.09%"
    expect(page).to have_content "52.17%"
  end
end
