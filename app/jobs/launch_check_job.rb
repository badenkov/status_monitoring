class LaunchCheckJob < ApplicationJob
  queue_as :default

  def perform(endpoint)
    endpoint.launch_check!
  end
end
