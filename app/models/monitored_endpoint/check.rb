class MonitoredEndpoint::Check < ApplicationRecord
  belongs_to :monitored_endpoint

  enum :status, { operational: 0, degraded: 1, incident: 2 }, default: :operational

  scope :by_date, ->(date) { where(created_at: date.all_day) }
  scope :chronologically, -> { order created_at: :asc, id: :asc }
end
