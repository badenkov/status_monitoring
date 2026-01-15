require "test_helper"

class MonitoredEndpointsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @monitored_endpoint = monitored_endpoints(:first_site)
  end

  test "should get index" do
    get monitored_endpoints_url

    assert_response :success
  end

  test "should get new" do
    get new_monitored_endpoint_url

    assert_response :success
  end

  test "should create monitored_endpoint" do
    assert_difference("MonitoredEndpoint.count") do
      post monitored_endpoints_url, params: {
        monitored_endpoint: {
          title: @monitored_endpoint.title,
          url: @monitored_endpoint.url,
          interval: @monitored_endpoint.interval,
          threshold: @monitored_endpoint.threshold,
        }
      }
    end

    assert_redirected_to monitored_endpoints_url
  end

  test "should get edit" do
    get edit_monitored_endpoint_url(@monitored_endpoint)

    assert_response :success
  end

  test "should update monitored_endpoint" do
    patch monitored_endpoint_url(@monitored_endpoint), params: {
      monitored_endpoint: {
        title: @monitored_endpoint.title,
        url: @monitored_endpoint.url,
        interval: @monitored_endpoint.interval,
        threshold: @monitored_endpoint.threshold,
      }
    }

    assert_redirected_to monitored_endpoints_url
  end

  test "should destroy monitored_endpoint" do
    assert_difference -> { MonitoredEndpoint.count }, -1 do
      delete monitored_endpoint_url(@monitored_endpoint)
    end

    assert_redirected_to monitored_endpoints_url
  end
end
