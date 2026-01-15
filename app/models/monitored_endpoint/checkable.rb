module MonitoredEndpoint::Checkable
  extend ActiveSupport::Concern

  def check_now
    return if in_progress?
    in_progress!

    response = perform_request

    transaction do
      checks.create!(latency: response[:latency], response_code: response[:code], status: response[:status])
      pending!
    end
  rescue 
    pending!
  end

  def check_later
    MonitoredEndpoint::CheckJob.perform_later(self)
  end

  private

    def perform_request
      start_time = MonitoredEndpoint::Checkable.gettime
      response = HTTP.get(url)
      end_time = MonitoredEndpoint::Checkable.gettime

      latency = (end_time - start_time).in_milliseconds
      status = get_status(response.code, latency, threshold)

      { code: response.code, latency:, status:}
    rescue => e
      { code: nil, latency: nil, status: :incident }
    end

    def get_status(response_code, latency, threshold)
      return :incident unless response_code && response_code.between?(200, 399)

      return :degraded if latency > threshold

      :operational
    end

    def self.gettime
      Process.clock_gettime(Process::CLOCK_MONOTONIC)
    end
end
