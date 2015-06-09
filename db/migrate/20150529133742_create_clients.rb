class CreateClients < ActiveRecord::Migration
  def change
    create_table :clients do |t|
      t.string :cuit
      t.string :slug

      t.timestamps null: false
    end
    add_index :clients, :slug, unique: true
  end
end
