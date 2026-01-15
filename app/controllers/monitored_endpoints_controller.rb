class MonitoredEndpointsController < ApplicationController
  before_action :set_monitored_endpoint, only: %i[ edit update destroy ]

  def index
    @monitored_endpoints = MonitoredEndpoint.all
  end

  def new
    @monitored_endpoint = MonitoredEndpoint.new
  end

  def edit
  end

  def create
    @monitored_endpoint = MonitoredEndpoint.new(monitored_endpoint_params)

    respond_to do |format|
      if @monitored_endpoint.save
        format.html { redirect_to monitored_endpoints_path, notice: "Monitored endpoint was successfully created." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @monitored_endpoint.update(monitored_endpoint_params)
        format.html { redirect_to monitored_endpoints_path, notice: "Monitored endpoint was successfully updated." }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @monitored_endpoint.destroy!

    respond_to do |format|
      format.html { redirect_to monitored_endpoints_path, status: :see_other, notice: "Monitored endpoint was successfully destroyed." }
    end
  end

  private
    def set_monitored_endpoint
      @monitored_endpoint = MonitoredEndpoint.find(params.expect(:id))
    end

    def monitored_endpoint_params
      params.expect(monitored_endpoint: [:title, :url, :threshold, :interval])
    end
end
