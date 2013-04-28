class CreateEmails < ActiveRecord::Migration
  def change
    create_table :emails do |t|
      t.string :username, :null => false
      t.string :password, :null => false
      t.string :email
      t.string :addtion
      t.integer :etype_id, :null => false
      t.integer :check,
      t.timestamps
    end
  end
end
