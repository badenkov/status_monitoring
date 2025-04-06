require "test_helper"

class LaunchScheduledChecksJobTest < ActiveJob::TestCase
  test "#perform" do
    first_site = monitored_endpoints(:first_site)
    first_site.ready!

    travel first_site.interval.seconds + 1.second do
      perform_enqueued_jobs(only: LaunchScheduledChecksJob) do
        LaunchScheduledChecksJob.perform_later
      end
    end

    assert first_site.reload.in_progress?
    assert_enqueued_with(job: LaunchCheckJob, args: [first_site])
  end
end
