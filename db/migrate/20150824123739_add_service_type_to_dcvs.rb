class AddServiceTypeToDcvs < ActiveRecord::Migration
  def change
    add_column :dcvs, :service_type, :string
  end
end
