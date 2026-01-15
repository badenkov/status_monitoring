module MonitoredEndpointScoped
  extend ActiveSupport::Concern

  included do
    before_action :set_monitored_endpoint
  end

  private
    def set_monitored_endpoint
      @monitored_endpoint = MonitoredEndpoint.find(params.expect(:monitored_endpoint_id))
    end
end
