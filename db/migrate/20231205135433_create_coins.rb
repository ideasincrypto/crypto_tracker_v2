class CreateCoins < ActiveRecord::Migration[7.1]
  def change
    create_table :coins do |t|
      t.string :name, null: false
      t.string :api_id, null: false
      t.string :ticker, null: false
      t.string :icon
      t.boolean :enabled, default: true

      t.timestamps
    end
  end
end
