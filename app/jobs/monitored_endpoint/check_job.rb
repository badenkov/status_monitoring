class MonitoredEndpoint::CheckJob < ApplicationJob
  queue_as :default

  def perform(check)
    check.perform_now
  end
end
