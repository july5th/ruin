class CreateEmailtypes < ActiveRecord::Migration
  def change
    create_table :emailtypes do |t|
      t.string :name, :null => false
      t.string :pop3
      t.string :smtp
      t.string :addtion
      t.timestamps
    end
  end
end
