class CreateDcvs < ActiveRecord::Migration
  def change
    create_table :dcvs do |t|
      t.integer :hard_disk
      t.integer :memory
      t.integer :cpu
      t.integer :bandwidth
      t.integer :client_id

      t.timestamps null: false
    end
  end
end
