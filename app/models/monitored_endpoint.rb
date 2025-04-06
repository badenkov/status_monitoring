class MonitoredEndpoint < ApplicationRecord
  URL_REGEXP = /\A(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?\z/ix

  has_many :checks, dependent: :destroy

  enum :status, { draft: 0, ready: 1, in_progress: 2 }, default: :draft

  validates :title, presence: true
  validates :url, presence: true, format: { with: URL_REGEXP, message: "should be valid url" }
  validates :threshold, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :interval, presence: true, numericality: { only_integer: true, greater_or_equal_than: 10 }

  scope :ready_for_launch, -> { ready.where("next_launch_at <= ?", Time.current) }

  broadcasts_refreshes

  before_save :calc_launch_time
  after_commit :launch_check_async, if: -> { in_progress? && status_previously_changed? }
  after_commit :flush_cache, if: -> { ready? && status_previously_changed? }

  def launch_check_async
    LaunchCheckJob.perform_later(self)
  end

  HTTP_TIMEOUT = 10

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

  def average_response_time
    checks.
      group_by_day(:created_at, reverse: true, range: (Date.today - 6)..Date.today).
      average(:latency)
  end

  def total_checks_counts
    checks.
      group_by_day(:created_at, reverse: true, range: (Date.today - 6)..Date.today).
      count
  end

  def incedent_counts
    checks.
      group_by_day(:created_at, reverse: true, range: (Date.today - 6)..Date.today).
      count("CASE WHEN monitored_endpoint_checks.response_code NOT BETWEEN 200 AND 399 THEN 1 END")
  end

  def degraded_counts
    checks.
      group_by_day(:created_at, reverse: true, range: (Date.today - 6)..Date.today).
      joins(:monitored_endpoint).
      count <<~SQL
              CASE
              WHEN (monitored_endpoint_checks.response_code BETWEEN 200 AND 399)
              AND  (monitored_endpoint_checks.latency > monitored_endpoints.threshold)
              THEN
                1
              END
            SQL
  end

  def cached_average_response_time
    Rails.cache.fetch([self.class.name, id, "average_response_time"]) { average_response_time }
  end

  def cached_total_checks_counts
    Rails.cache.fetch([self.class.name, id, "total_checks_counts"]) { total_checks_counts }
  end

  def cached_incedent_counts
    Rails.cache.fetch([self.class.name, id, "incedent_counts"]) { incedent_counts }
  end

  def cached_degraded_counts
    Rails.cache.fetch([self.class.name, id, "degraded_counts"]) { degraded_counts }
  end

  def flush_cache
    Rails.cache.delete([self.class.name, id, "average_response_time"])
    Rails.cache.delete([self.class.name, id, "total_checks_counts"])
    Rails.cache.delete([self.class.name, id, "incedent_counts"])
    Rails.cache.delete([self.class.name, id, "degraded_counts"])
  end

  private

  def calc_launch_time
    self.next_launch_at = nil if draft? || in_progress?
    self.next_launch_at = Time.now + interval.seconds if ready?
  end
end
