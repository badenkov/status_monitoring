class MonitoredEndpoint::PerformScheduledChecksJob < ApplicationJob
  queue_as :default

  def perform
    MonitoredEndpoint.ready_for_launch.find_each do |endpoint|
      endpoint.check_now
    end
  end
end
