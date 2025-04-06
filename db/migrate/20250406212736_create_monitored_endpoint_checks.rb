class CreateMonitoredEndpointChecks < ActiveRecord::Migration[8.0]
  def change
    create_table :monitored_endpoint_checks do |t|
      t.references :monitored_endpoint, null: false, foreign_key: true
      t.integer :response_code
      t.integer :latency

      t.timestamps
    end
  end
end
