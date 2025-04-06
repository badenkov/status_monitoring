require "test_helper"

class LaunchCheckJobTest < ActiveJob::TestCase
  test "check endpoint" do
    freeze_time

    first_site = monitored_endpoints(:first_site)
    stub_request(:get, first_site.url).to_return(->(request) {
      travel 1.seconds
      { status: 200, body: "", headers: {} }
    })

    assert_difference -> { MonitoredEndpoint::Check.count }, 1 do
      perform_enqueued_jobs(only: LaunchCheckJob) do
        LaunchCheckJob.perform_later(first_site)
      end
    end
    travel_back

    check = first_site.reload.checks.order(id: :desc).first

    assert_equal check.latency, 1000
    assert_equal check.response_code, 200
  end
end
