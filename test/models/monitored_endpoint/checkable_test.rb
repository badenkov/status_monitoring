require "test_helper"

class MonitoredEndpoint::CheckableTest < ActiveSupport::TestCase
  setup do
    @monitored_endpoint = monitored_endpoints(:first_site)
    freeze_time Time.zone.parse("2026-01-15 12:15:00")
  end

  test ".check_now - success response" do
    stubed_request = stub_request(:get, @monitored_endpoint.url).to_return(status: 200)
    MonitoredEndpoint::Checkable.stubs(:gettime).returns(100.00, 200.00)

    assert_difference -> { MonitoredEndpoint::Check.count }, 1 do
      @monitored_endpoint.check_now
    end

    check = MonitoredEndpoint::Check.last
    assert check.operational?
    assert_equal 100_000, check.latency
    assert_equal 200, check.response_code
    assert_equal @monitored_endpoint, check.monitored_endpoint

    assert_requested stubed_request

    @monitored_endpoint.reload
    assert_equal Time.zone.parse("2026-01-15 12:16:00").utc, @monitored_endpoint.next_launch_at.utc
  end

  test ".check_now - long response" do
    stubed_request = stub_request(:get, @monitored_endpoint.url).to_return(status: 200)
    MonitoredEndpoint::Checkable.stubs(:gettime).returns(100.00, 310.00)

    assert_difference -> { MonitoredEndpoint::Check.count }, 1 do
      @monitored_endpoint.check_now
    end

    check = MonitoredEndpoint::Check.last
    assert check.degraded?
    assert_equal 210.in_milliseconds, check.latency
    assert_equal 200, check.response_code
    assert_equal @monitored_endpoint, check.monitored_endpoint

    assert_requested stubed_request

    @monitored_endpoint.reload
    assert_equal Time.zone.parse("2026-01-15 12:16:00").utc, @monitored_endpoint.next_launch_at.utc
  end

  test ".check_now - error response" do
    stubed_request = stub_request(:get, @monitored_endpoint.url).to_return(status: 500)
    MonitoredEndpoint::Checkable.stubs(:gettime).returns(100.00, 200.00)

    assert_difference -> { MonitoredEndpoint::Check.count }, 1 do
      @monitored_endpoint.check_now
    end

    check = MonitoredEndpoint::Check.last
    assert check.incident?
    assert_equal 100_000, check.latency
    assert_equal 500, check.response_code
    assert_equal @monitored_endpoint, check.monitored_endpoint

    assert_requested stubed_request

    @monitored_endpoint.reload
    assert_equal Time.zone.parse("2026-01-15 12:16:00").utc, @monitored_endpoint.next_launch_at.utc
  end

  test ".check_later" do
    @monitored_endpoint.check_later

    assert_enqueued_with job: MonitoredEndpoint::CheckJob, args: [ @monitored_endpoint ]
  end
end
