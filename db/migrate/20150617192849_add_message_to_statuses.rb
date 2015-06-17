class AddMessageToStatuses < ActiveRecord::Migration
  def change
    add_column :statuses, :message, :string
  end
end
