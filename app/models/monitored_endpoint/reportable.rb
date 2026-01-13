module MonitoredEndpoint::Reportable
  extend ActiveSupport::Concern

  included do
    after_commit :flush_cache, if: -> { ready? && status_previously_changed? }
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
end
