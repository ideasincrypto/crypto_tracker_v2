require "rails_helper"

describe "User Creates a new portfolio", js: true do
  it "from the home page" do
    user = User.create!(email: "user@email.com", password: "123456")

    login_as user, scope: :user
    visit root_path
    within("turbo-frame[id='portfolios_console']") do
      find("#new_portfolio_button").click
    end

    within("turbo-frame[id='management_console']")
    expect(page).to have_content "New Portfolio"
    expect(page).to have_field "Portfolio name"
    expect(page).to have_button "Create"
  end
  it "successfully" do
    user = User.create!(email: "user@email.com", password: "123456")

    login_as user, scope: :user
    visit root_path
    within("turbo-frame[id='portfolios_console']") do
      find("#new_portfolio_button").click
    end
    within("turbo-frame[id='management_console']") do
      fill_in "Portfolio name", with: "My Portfolio"
      click_on "Create"
    end

    within("turbo-frame[id='portfolios_console']") do
      expect(page).to have_content "My Portfolio"
      expect(page).to have_content "$0.00"
    end
    expect(Portfolio.all.count).to eq 1
    expect(user.account.portfolios.last.name).to eq "My Portfolio"
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
