return unless Rails.env.development?

puts "\n== Seeding the database with fixtures =="
system("bin/rails db:fixtures:load")
