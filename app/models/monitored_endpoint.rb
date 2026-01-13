class MonitoredEndpoint < ApplicationRecord
  include Report

  HTTP_TIMEOUT = 10

  has_many :checks, dependent: :destroy

  enum :status, { draft: 0, ready: 1, in_progress: 2 }, default: :draft

  validates :title, presence: true
  validates :url, presence: true, format: { with: URI.regexp, message: "should be valid url" }
  validates :threshold, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :interval, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1.minute, less_than_or_equal_to: 1.hour }

  scope :ready_for_launch, -> { ready.where("next_launch_at <= ?", Time.current) }

  broadcasts_refreshes

  before_save :calc_launch_time
  after_commit :launch_check_async, if: -> { in_progress? && status_previously_changed? }

  def launch_check_async
    LaunchCheckJob.perform_later(self)
  end

  def launch_check!
    start_time = Time.current
    begin
      response = HTTP.timeout(HTTP_TIMEOUT).get(url)
      response_code = response.code
    rescue HTTP::TimeoutError => e
      response_code = 504
    end
    end_time = Time.current

    latency = (end_time - start_time).in_milliseconds

    transaction do
      self.lock!
      self.checks.create!(latency: latency, response_code: response_code)
      self.ready!
    end
  end

  private

  def calc_launch_time
    self.next_launch_at = nil if draft? || in_progress?
    self.next_launch_at = Time.now + interval.seconds if ready?
  end
end
