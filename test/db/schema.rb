ActiveRecord::Schema.define(:version => 20090217091952) do

  create_table "users", :force => true do |t|
    t.string   "name"
    t.integer  "account_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end
  
  create_table "accounts", :force => true do |t|
    t.string   "name"
    t.timestamp
  end
  
  create_table "categories", :force => true do |t|
    t.string   "name"
    t.timestamp
  end
  
  create_table "posts", :force => true do |t|
    t.string   "name"
    t.integer  "user_id"
    t.integer  "category_id"
    t.timestamp
  end
  
  create_table "comments", :force => true do |t|
    t.string   "name"
    t.integer  "user_id"
    t.integer  "post_id"
    t.integer  "comment_id"
    t.timestamp
  end

  
end
