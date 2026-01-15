return unless Rails.env.development?

# puts "\n== Seeding the database with fixtures =="
# system("bin/rails db:fixtures:load")

site = MonitoredEndpoint.create!(
  title: "First site",
  url: "https://first-site.test",
  threshold: 100,
  interval: 60,
)

100.times do |day|
  current_date = day.days.ago.to_date

  if day.in? [ 3, 10, 15]
    site.checks.create!(status: :degraded, created_at: current_date + 12.hour + 15.minutes, latency: 200 + rand(30..100))
  end

  if day.in? [ 7, 9, 25]
    site.checks.create!(status: :incident, created_at: current_date + 12.hour + 15.minutes, latency: 50 + rand(30..40))
  end

  site.checks.create!(status: :operational, created_at: current_date + 12.hour + 5.minutes, latency: 50 + rand(30..40))
  site.checks.create!(status: :operational, created_at: current_date + 18.hour + 10.minutes, latency: 50 + rand(30..40))
  site.checks.create!(status: :operational, created_at: current_date + 22.hour + 15.minutes, latency: 50 + rand(30..40))
end
