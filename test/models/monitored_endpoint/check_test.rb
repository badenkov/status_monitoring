require "test_helper"

class MonitoredEndpoint::CheckTest < ActiveSupport::TestCase
  test ".perform_now" do
    first_site = monitored_endpoints(:first_site)
    stubed_request = stub_request(:get, first_site.url).to_return(status: 200)
    MonitoredEndpoint::Check.stubs(:gettime).returns(100.00, 200.00)

    check = first_site.checks.create!
    check.perform_now
    
    assert_requested stubed_request
    assert_equal 100_000, check.latency
    assert_equal 200, check.response_code
  end

  test ".perform_now - error" do
    first_site = monitored_endpoints(:first_site)
    stubed_request = stub_request(:get, first_site.url).to_return(status: 500)
    MonitoredEndpoint::Check.stubs(:gettime).returns(100.00, 200.00)

    check = first_site.checks.create!
    check.perform_now
    
    assert_requested stubed_request
    assert_equal 100_000, check.latency
    assert_equal 500, check.response_code
  end

  test "xxx" do
    travel_to Date.parse("2026-01-13 12:00")
    first_site = monitored_endpoints(:first_site)

    7.times do |day|
      current_date = day.days.ago.to_date
      first_site.checks.create!(status: :operational, created_at: current_date + 12.hour + 5.minutes)
      first_site.checks.create!(status: :operational, created_at: current_date + 12.hour + 10.minutes)
      first_site.checks.create!(status: :operational, created_at: current_date + 12.hour + 15.minutes)
      if day == 3
        first_site.checks.create!(status: :degraded, created_at: current_date + 12.hour + 15.minutes)
      end
    end


    binding.irb
  end
end
