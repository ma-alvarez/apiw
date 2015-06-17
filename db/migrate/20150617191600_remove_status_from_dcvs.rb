class RemoveStatusFromDcvs < ActiveRecord::Migration
  def change
    remove_column :dcvs, :status, :integer
  end
end
