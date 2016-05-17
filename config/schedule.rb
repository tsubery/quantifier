require "whenever"

set :output, "#{path}/log/cron_log.log"
set :environment, @environment

every 1.hour do
  runner "BeeminderWorker.perform_async"
end

every 1.day do
  runner "BackupWorker.perform_async"
end
