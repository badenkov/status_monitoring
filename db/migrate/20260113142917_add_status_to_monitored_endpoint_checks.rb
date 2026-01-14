class AddStatusToMonitoredEndpointChecks < ActiveRecord::Migration[8.1]
  def change
    add_column :monitored_endpoint_checks, :status, :integer, default: 0
  end
end
