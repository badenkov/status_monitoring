class LaunchScheduledChecksJob < ApplicationJob
  queue_as :default

  def perform
    MonitoredEndpoint.ready_for_launch.find_each do |endpoint|
      endpoint.in_progress!
    end
  end
end
