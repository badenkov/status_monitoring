require "application_system_test_case"

class MonitoredEndpointsTest < ApplicationSystemTestCase
  setup do
    @monitored_endpoint = monitored_endpoints(:one)
  end

  test "visiting the index" do
    visit monitored_endpoints_url
    assert_selector "h1", text: "Monitored endpoints"
  end

  test "should create monitored endpoint" do
    visit monitored_endpoints_url
    click_on "New monitored endpoint"

    fill_in "Interval", with: @monitored_endpoint.interval
    fill_in "Next launch at", with: @monitored_endpoint.next_launch_at
    fill_in "Status", with: @monitored_endpoint.status
    fill_in "Threshold", with: @monitored_endpoint.threshold
    fill_in "Title", with: @monitored_endpoint.title
    fill_in "Url", with: @monitored_endpoint.url
    click_on "Create Monitored endpoint"

    assert_text "Monitored endpoint was successfully created"
    click_on "Back"
  end

  test "should update Monitored endpoint" do
    visit monitored_endpoint_url(@monitored_endpoint)
    click_on "Edit this monitored endpoint", match: :first

    fill_in "Interval", with: @monitored_endpoint.interval
    fill_in "Next launch at", with: @monitored_endpoint.next_launch_at.to_s
    fill_in "Status", with: @monitored_endpoint.status
    fill_in "Threshold", with: @monitored_endpoint.threshold
    fill_in "Title", with: @monitored_endpoint.title
    fill_in "Url", with: @monitored_endpoint.url
    click_on "Update Monitored endpoint"

    assert_text "Monitored endpoint was successfully updated"
    click_on "Back"
  end

  test "should destroy Monitored endpoint" do
    visit monitored_endpoint_url(@monitored_endpoint)
    accept_confirm { click_on "Destroy this monitored endpoint", match: :first }

    assert_text "Monitored endpoint was successfully destroyed"
  end
end
