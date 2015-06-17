class CreateStatuses < ActiveRecord::Migration
  def change
    create_table :statuses do |t|
      t.integer :dcv_id
      t.integer :status, default:0
      t.string :token
      t.timestamps null: false
    end
  end
end
