class AddClientIdToSvps < ActiveRecord::Migration
  def change
    add_column :svps, :client_id, :integer
  end
end
