class AddBwavginToDcvs < ActiveRecord::Migration
  def change
    add_column :dcvs, :bw_avg_in, :integer
    add_column :dcvs, :bw_avg_out, :integer
    add_column :dcvs, :bw_peak_in, :integer
    add_column :dcvs, :bw_peak_out, :integer
    add_column :dcvs, :public_ip_count, :integer
    add_column :dcvs, :ip_net_web, :string
    add_column :dcvs, :ip_net_application, :string
    add_column :dcvs, :ip_net_backend, :string
    add_column :dcvs, :edge_high_availability, :boolean
  end
end
