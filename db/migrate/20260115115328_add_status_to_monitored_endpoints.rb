class AddStatusToMonitoredEndpoints < ActiveRecord::Migration[8.1]
  def change
    remove_column :monitored_endpoints, :status
    add_column :monitored_endpoints, :status, :string, default: "pending"
  end
end
