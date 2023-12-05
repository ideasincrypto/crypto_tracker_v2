class CreateHoldings < ActiveRecord::Migration[7.1]
  def change
    create_table :holdings do |t|
      t.references :coin, null: false, foreign_key: true
      t.decimal :amount, default: 0.0

      t.timestamps
    end
  end
end
