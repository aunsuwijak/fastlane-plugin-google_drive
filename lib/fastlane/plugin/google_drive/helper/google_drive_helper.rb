require 'fastlane_core/ui/ui'
require 'google_drive'
module Fastlane
  UI = FastlaneCore::UI unless Fastlane.const_defined?("UI")

  module Helper
    class GoogleDriveHelper
      def self.setup(keyfile: nil, service_account: false)
        if service_account
          ::GoogleDrive::Session.from_service_account_key(keyfile)
        else
          ::GoogleDrive::Session.from_config(keyfile)
        end
      rescue Exception => e
        UI.error(e.message)
        UI.user_error!('Invalid Google Drive credentials')
      end

      def self.file_by_id(session: nil, fid: nil)
        file = session.file_by_id(fid)
        file
      rescue Exception => e
        UI.error(e.message)
        UI.user_error!("File with id '#{fid}' not found in Google Drive")
      end

      def self.upload_file(file: nil, file_name: nil, title: nil)
        raise "Not Google Drive file" unless file.kind_of?(::GoogleDrive::File)

        begin
          file = file.upload_from_file(file_name, title)
          file
        rescue Exception => e
          UI.error(e.message)
          UI.user_error!("Upload '#{file_name}' failed")
        end
      end

      def self.create_subcollection(root_folder:, title:)
        root_folder.create_subcollection(title)
      rescue Exception => e
        UI.error(e.message)
        UI.user_error!("Create '#{title}' failed")
      end
    end
  end
end
