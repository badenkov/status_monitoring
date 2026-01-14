class MonitoredEndpoint::Check < ApplicationRecord
  belongs_to :monitored_endpoint

  enum :status, { operational: 0, degraded: 1, incident: 2 }, default: :operational

  def perform_now
    start_time = self.class.gettime
    begin
      response = HTTP.get(monitored_endpoint.url)
      response_code = response.code
    rescue
      response_code = 500
    end
    end_time = self.class.gettime

    latency = (end_time - start_time).in_milliseconds
    update!(latency: latency, response_code: response_code)
  end

  private
    def self.gettime
      Process.clock_gettime(Process::CLOCK_MONOTONIC)
    end
end
