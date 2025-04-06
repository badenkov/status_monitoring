class CreateMonitoredEndpoints < ActiveRecord::Migration[8.0]
  def change
    create_table :monitored_endpoints do |t|
      t.string :title
      t.string :url
      t.integer :threshold
      t.integer :interval
      t.datetime :next_launch_at
      t.integer :status, default: 0

      t.timestamps
    end

    add_index :monitored_endpoints, :status
  end
end
