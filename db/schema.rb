# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2023_12_11_205638) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.string "uuid", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_accounts_on_user_id"
    t.index ["uuid"], name: "unique_uuids", unique: true
  end

  create_table "coins", force: :cascade do |t|
    t.string "name", null: false
    t.string "api_id", null: false
    t.string "ticker", null: false
    t.string "icon"
    t.boolean "enabled", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "rate", default: "0.0"
    t.index ["api_id"], name: "unique_api_id_index", unique: true
    t.index ["name"], name: "unique_name_index", unique: true
    t.index ["ticker"], name: "unique_icon_index", unique: true
    t.index ["ticker"], name: "unique_ticker_index", unique: true
  end

  create_table "holdings", force: :cascade do |t|
    t.bigint "coin_id", null: false
    t.decimal "amount", default: "0.0"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "portfolio_id", null: false
    t.index ["coin_id"], name: "index_holdings_on_coin_id"
    t.index ["portfolio_id"], name: "index_holdings_on_portfolio_id"
  end

  create_table "portfolios", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_portfolios_on_account_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "accounts", "users"
  add_foreign_key "holdings", "coins"
  add_foreign_key "holdings", "portfolios"
  add_foreign_key "portfolios", "accounts"
end
