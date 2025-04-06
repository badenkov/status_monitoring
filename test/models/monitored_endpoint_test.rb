require "test_helper"

class MonitoredEndpointTest < ActiveSupport::TestCase
  test "calculate launch time" do
    freeze_time

    first_site = monitored_endpoints(:first_site)
    first_site.ready!

    assert first_site.next_launch_at == Time.current + first_site.interval

    first_site.in_progress!

    assert first_site.next_launch_at == nil
  end
end
