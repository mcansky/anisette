class FixingPasswordDuplicate < ActiveRecord::Migration
  def self.up
		drop_table :users
		create_table "users", :force => true do |t|
			t.string   "email",             :limit => 100
			t.string   "crypted_password"
			t.datetime "created_at"
			t.datetime "updated_at"
			t.string   "password_salt"
			t.string   "persistence_token"
			t.string   "login"
		end
  end

  def self.down
		drop_table :users
		create_table "users", :force => true do |t|
			t.string   "email",             :limit => 100
			t.string   "crypted_password"
			t.datetime "created_at"
			t.datetime "updated_at"
			t.string   "password_salt"
			t.string   "persistence_token"
			t.string   "login"
		end
  end
end
