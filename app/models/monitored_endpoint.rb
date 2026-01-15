class MonitoredEndpoint < ApplicationRecord
  include Scheduable, Checkable

  has_many :checks, dependent: :destroy

  enum :status, %w[ pending in_progress ].index_by(&:itself), default: :pending

  validates :title, presence: true
  validates :url, presence: true, format: { with: URI.regexp, message: "should be valid url" }
  validates :threshold, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :interval, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1.minute, less_than_or_equal_to: 1.hour }

  broadcasts_refreshes
  
  def statuses_by_day(from:, to:)
    checks.group_by_day(:created_at, range: from..to, series: true)
      .maximum(:status)
      .transform_values { |v| v.nil? ? nil : MonitoredEndpoint::Check.statuses.key(v) }
  end

  def response_status
    checks.chronologically.last&.status
  end
end
