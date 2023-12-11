class AddRateToCoin < ActiveRecord::Migration[7.1]
  def change
    add_column :coins, :rate, :decimal, default: "0.0"
  end
end
