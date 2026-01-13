module MonitoredEndpoint::Scheduable
  extend ActiveSupport::Concern

  included do
    before_save :calc_launch_time
    scope :ready_for_launch, -> { ready.where("next_launch_at <= ?", Time.current) }
  end

  private

    def calc_launch_time
      if ready?
        self.next_launch_at = Time.current + interval.seconds if ready?
      else
        self.next_launch_at = nil
      end
    end
end
