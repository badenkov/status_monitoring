class MonitoredEndpoints::DailyDetailsController < ApplicationController
  include MonitoredEndpointScoped
  before_action :set_date, only: %i[ show ]

  def show
    @checks = @monitored_endpoint.checks.by_date(@date).not_operational.chronologically
  end

  private
    def set_date
      @date = Date.parse(params.expect(:date))
    end
end
