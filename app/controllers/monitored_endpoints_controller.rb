class MonitoredEndpointsController < ApplicationController
  before_action :set_monitored_endpoint, only: %i[ show edit update destroy ]

  def index
    @monitored_endpoints = MonitoredEndpoint.all
  end

  def show
    @average_response_time = @monitored_endpoint.cached_average_response_time
    @total_checks_counts = @monitored_endpoint.cached_total_checks_counts
    @incedent_counts = @monitored_endpoint.cached_incedent_counts
    @degraded_counts = @monitored_endpoint.cached_degraded_counts
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
        format.html { redirect_to @monitored_endpoint, notice: "Monitored endpoint was successfully created." }
        format.json { render :show, status: :created, location: @monitored_endpoint }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @monitored_endpoint.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @monitored_endpoint.update(monitored_endpoint_params)
        format.html { redirect_to @monitored_endpoint, notice: "Monitored endpoint was successfully updated." }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @monitored_endpoint.destroy!

    respond_to do |format|
      format.html { redirect_to monitored_endpoints_path, status: :see_other, notice: "Monitored endpoint was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_monitored_endpoint
    @monitored_endpoint = MonitoredEndpoint.find(params.expect(:id))
  end

  # Only allow a list of trusted parameters through.
  def monitored_endpoint_params
    params.expect(monitored_endpoint: [:title, :url, :threshold, :interval, :next_launch_at, :status])
  end
end
