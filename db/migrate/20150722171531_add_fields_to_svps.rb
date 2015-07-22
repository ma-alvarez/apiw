class AddFieldsToSvps < ActiveRecord::Migration
  def change
    add_column :svps, :memory, :integer
    add_column :svps, :cpu, :integer
    add_column :svps, :hard_disk, :integer
  end
end
