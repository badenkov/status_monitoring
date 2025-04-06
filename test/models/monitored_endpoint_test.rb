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

  test "report" do
    first_site = monitored_endpoints(:first_site)

    today = monitored_endpoint_checks(:first_site_operational1).created_at.to_date
    yesterday = monitored_endpoint_checks(:first_site_incedent).created_at.to_date
    before_yesterday = monitored_endpoint_checks(:first_site_degraded).created_at.to_date

    assert_equal first_site.total_checks_counts[today], 2
    assert_equal first_site.total_checks_counts[yesterday], 1
    assert_equal first_site.total_checks_counts[before_yesterday], 1

    assert_equal first_site.incedent_counts[today], 0
    assert_equal first_site.incedent_counts[yesterday], 1
    assert_equal first_site.incedent_counts[before_yesterday], 0

    assert_equal first_site.degraded_counts[today], 0
    assert_equal first_site.degraded_counts[yesterday], 0
    assert_equal first_site.degraded_counts[before_yesterday], 1

    assert_equal first_site.average_response_time[today].round, 100
    assert_equal first_site.average_response_time[yesterday].round, 100
    assert_equal first_site.average_response_time[before_yesterday].round, 150
  end
end
