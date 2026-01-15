module MonitoredEndpoint::Scheduable
  extend ActiveSupport::Concern

  included do
    scope :ready_for_launch, -> { pending.where("next_launch_at <= ?", Time.current) }

    before_save :calc_launch_time
  end

  private

    def calc_launch_time
      if pending?
        self.next_launch_at = Time.current + interval.seconds
      else
        self.next_launch_at = nil
      end
    end
end
