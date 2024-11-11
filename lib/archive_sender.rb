# require 'sidekiq'
# require 'pony'

# class ArchiveSender
#   include Sidekiq::Worker

#   def perform(archive_file)
#     Pony.mail(
#       to: 'recipient@example.com',
#       subject: 'Archived Results',
#       body: 'Here is the archive of the results.',
#       attachments: { File.basename(archive_file) => File.read(archive_file) }
#     )
#     StoreApplication::LoggerManager.log_processed_file("Archive sent to email.")
#   rescue => e
#     StoreApplication::LoggerManager.log_error("Failed to send archive: #{e.message}")
#   end
# end
