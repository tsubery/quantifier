class BackupWorker
  include Sidekiq::Worker

  def perform
    Timeout::timeout(120) {
      PgDrive.perform
    }
  rescue Timeout::Error
    logger.error("Backup timeout")
  end
end
