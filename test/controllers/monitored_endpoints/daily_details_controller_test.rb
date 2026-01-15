require "test_helper"

class MonitoredEndpoints::DailyDetailsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @monitored_endpoint = monitored_endpoints(:first_site)
  end

  test "show" do
    get monitored_endpoint_daily_detail_url(@monitored_endpoint, @monitored_endpoint.checks.last.created_at.to_date.to_s)

    assert_response :success
  end
end
