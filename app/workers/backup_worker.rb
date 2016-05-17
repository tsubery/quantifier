class BackupWorker
  include Sidekiq::Worker

  def perform
    PgDrive.perform
  end
end
