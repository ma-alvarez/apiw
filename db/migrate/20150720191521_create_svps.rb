class CreateSvps < ActiveRecord::Migration
  def change
    create_table :svps do |t|
      t.string :blueprint_id
      t.string :name

      t.timestamps null: false
    end
  end
end
