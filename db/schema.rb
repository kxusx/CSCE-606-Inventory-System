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

ActiveRecord::Schema[8.0].define(version: 2025_02_08_192915) do
  create_table "bins", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "name"
    t.string "location"
    t.string "category_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_bins_on_user_id"
  end

  create_table "items", force: :cascade do |t|
    t.integer "bin_id"
    t.string "name"
    t.text "description"
    t.datetime "created_date"
    t.decimal "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bin_id"], name: "index_items_on_bin_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.integer "bins_count", default: 0, null: false
  end

  add_foreign_key "bins", "users"
  add_foreign_key "items", "bins"
end
