
set :output, "log/cron_airport_json.log"
set :environment, "development"

env :PATH, '/home/dell/.rbenv/shims:/usr/local/bin:/usr/bin:/bin'
env :HOME, '/home/dell'

every 1.day, at: '3:00 am' do
  rake "scrape:airport_json"
end
# every 3.minute do
#   rake "scrape:airport_json"
# end