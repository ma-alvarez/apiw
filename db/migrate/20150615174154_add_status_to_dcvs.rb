class AddStatusToDcvs < ActiveRecord::Migration
  def change
    add_column :dcvs, :status, :integer, default:0
  end
end
