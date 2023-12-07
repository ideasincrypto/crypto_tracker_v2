class AddPortfolioIdToHolding < ActiveRecord::Migration[7.1]
  def change
    add_reference :holdings, :portfolio, null: false, foreign_key: true
  end
end
