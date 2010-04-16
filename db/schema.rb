# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 11) do

  create_table "books", :force => true do |t|
    t.integer "oclc",                :limit => 11
    t.string  "internal_identifier"
    t.string  "volume"
    t.string  "chronology"
    t.string  "call_number"
    t.string  "author"
    t.string  "publisher_place"
    t.string  "publisher"
    t.string  "title"
    t.integer "picklist_id",         :limit => 11
  end

  add_index "books", ["oclc"], :name => "index_books_on_oclc"
  add_index "books", ["title"], :name => "index_books_on_title"
  add_index "books", ["author"], :name => "index_books_on_author"

  create_table "institutions", :force => true do |t|
    t.string "name"
  end

  create_table "picklists", :force => true do |t|
    t.integer  "institution_id", :limit => 11
    t.string   "content_type"
    t.integer  "size",           :limit => 11
    t.string   "filename"
    t.integer  "header_row",     :limit => 11
    t.text     "header_map"
    t.datetime "created_at"
  end

end
