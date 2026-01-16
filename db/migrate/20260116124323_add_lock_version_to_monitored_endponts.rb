class AddLockVersionToMonitoredEndponts < ActiveRecord::Migration[8.1]
  def change
    add_column :monitored_endpoints, :lock_version, :integer, default: 0, null: false
  end
end
