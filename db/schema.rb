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

ActiveRecord::Schema.define(version: 2026_04_13_230002) do

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.integer "record_id", null: false
    t.integer "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.integer "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.integer "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "notes", force: :cascade do |t|
    t.text "content"
    t.integer "person_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["person_id"], name: "index_notes_on_person_id"
  end

  create_table "parentships", force: :cascade do |t|
    t.integer "person_id"
    t.integer "father_id"
    t.integer "mother_id"
    t.index ["father_id"], name: "index_parentships_on_father_id"
    t.index ["mother_id"], name: "index_parentships_on_mother_id"
    t.index ["person_id"], name: "index_parentships_on_person_id"
  end

  create_table "partnerships", force: :cascade do |t|
    t.integer "person_id"
    t.integer "partner_id"
    t.date "date_started"
    t.date "date_ended"
    t.string "nature"
    t.index ["partner_id"], name: "index_partnerships_on_partner_id"
    t.index ["person_id"], name: "index_partnerships_on_person_id"
  end

  create_table "people", force: :cascade do |t|
    t.string "name"
    t.string "gender"
    t.text "bio"
    t.date "date_of_birth"
    t.date "date_of_death"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "location_of_birth"
    t.string "location_of_death"
    t.string "chart_id"
    t.index ["chart_id"], name: "index_people_on_chart_id", unique: true
  end

  create_table "versions", force: :cascade do |t|
    t.string "item_type"
    t.string "{:null=>false}"
    t.integer "item_id", limit: 8, null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object", limit: 1073741823
    t.datetime "created_at"
    t.text "object_changes", limit: 1073741823
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "notes", "people"
  add_foreign_key "parentships", "people"
  add_foreign_key "parentships", "people", column: "father_id"
  add_foreign_key "parentships", "people", column: "mother_id"
  add_foreign_key "partnerships", "people"
  add_foreign_key "partnerships", "people", column: "partner_id"
end
