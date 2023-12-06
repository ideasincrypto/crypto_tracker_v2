require "rails_helper"

describe "User Creates a new portfolio" do
  it "successfully" do
    user = User.create!(email: "user@email.com", password: "123456")

    login_as user, scope: :user
    visit new_portfolio_path
    fill_in "Portfolio name", with: "My Portfolio"
    click_on "Create"

    expect(Portfolio.all.count).to eq 1
    expect(user.account.portfolios.last.name).to eq "My Portfolio"
    expect(page).to have_content "Portfolio created successfuly"
    expect(page).to have_content "My Portfolio"
    expect(page).to have_content "Your portfolio is empty. Add coins to see them here"
    expect(page).to have_link "Add Coins"
  end

  it "unsuccessfully without name" do
    user = User.create!(email: "user@email.com", password: "123456")

    login_as user, scope: :user
    visit new_portfolio_path
    fill_in "Portfolio name", with: ""
    click_on "Create"

    expect(page).to have_content "ERROR: couldn't save portfolio"
    expect(page).to have_content "Name can't be blank"
    expect(Portfolio.all.count).to eq 0
    expect(user.account.portfolios).to be_empty
  end
end
