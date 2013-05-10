class CreateProxies < ActiveRecord::Migration
  def change
    create_table :proxies do |t|
      t.string :ip, :null => false
      t.integer :port, :null => false
      t.integer :level, :default => 0
      t.integer :error, :default => 0
      t.integer :https, :default => 0
      t.string :addr
      t.string :addtion
      t.timestamps
    end
  end
end
