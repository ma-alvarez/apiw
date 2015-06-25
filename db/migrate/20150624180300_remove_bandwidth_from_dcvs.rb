class RemoveBandwidthFromDcvs < ActiveRecord::Migration
  def change
    remove_column :dcvs, :bandwidth, :integer
  end
end
