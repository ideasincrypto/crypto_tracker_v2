require "rails_helper"

describe "User Creates a new portfolio" do
  it "successfuly" do
    user = User.create!(email: "user@email.com", password: "123456")

    login_as user, scope: :user
    visit new_portfolio_path
    fill_in "Portfolio name", with: "My Portfolio"
    click_on "Create"

    expect(page).to have_content "My Portfolio"
    expect(page).to have_content "Your portfolio is empty. Add coins to see them here"
    expect_page.to have_link "Add Coin"
  end
end
