class MonitoredEndpoint < ApplicationRecord
  URL_REGEXP = /\A(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?\z/ix

  enum :status, { draft: 0, ready: 1, in_progress: 2 }, default: :draft

  validates :title, presence: true
  validates :url, presence: true, format: { with: URL_REGEXP, message: "should be valid url" }
  validates :threshold, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :interval, presence: true, numericality: { only_integer: true, greater_or_equal_than: 10 }

  broadcasts_refreshes

  before_save :calc_launch_time

  private

  def calc_launch_time
    self.next_launch_at = nil if draft? || in_progress?
    self.next_launch_at = Time.now + interval.seconds if ready?
  end
end
