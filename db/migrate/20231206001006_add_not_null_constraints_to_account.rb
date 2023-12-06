class AddNotNullConstraintsToAccount < ActiveRecord::Migration[7.1]
  def change
    change_column_null :accounts, :uuid, false
  end
end
