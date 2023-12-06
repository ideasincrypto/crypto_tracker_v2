class CreateAccounts < ActiveRecord::Migration[7.1]
  def change
    create_table :accounts do |t|
      t.string :uuid, index: { unique: true, name: "unique_uuids" }
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
