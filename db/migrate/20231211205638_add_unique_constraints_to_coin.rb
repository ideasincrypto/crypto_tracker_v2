class AddUniqueConstraintsToCoin < ActiveRecord::Migration[7.1]
  def change
    add_index :coins, :name, unique: true, name: "unique_name_index"
    add_index :coins, :api_id, unique: true, name: "unique_api_id_index"
    add_index :coins, :ticker, unique: true, name: "unique_ticker_index"
    add_index :coins, :ticker, unique: true, name: "unique_icon_index"
  end
end
