class MonitoredEndpoints::DailyDetailsController < ApplicationController
  def show
    @date = params.expect(:date)
  end
end
