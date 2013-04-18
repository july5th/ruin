class CreateProxies < ActiveRecord::Migration
  def change
    create_table :proxies do |t|
      t.string :ip, :null => false
      t.integer :port, :null => false
      t.string :addr
      t.string :addtion

      t.timestamps
    end
  end
end
