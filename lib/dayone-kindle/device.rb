module DayOneKindle
  class Device
    CLIPPINGS_PATH = '/documents/My Clippings.txt'.freeze
    VERSION_PATH = '/system/version.txt'.freeze
    BACKUP_PATH = '/clippings-backups'.freeze
    BACKUP_NAME = '%Y%m%d-%H%M%S.txt'.freeze

    attr_reader :path, :name, :clippings_path, :clippings_backups_path

    def initialize(path, name)
      @path = path
      @name = name
      @clippings_path = File.join(path, CLIPPINGS_PATH)
      @clippings_backups_path = File.join(path, BACKUP_PATH)
    end

    def highlights
      ClippingsParser.new(raw_clippings).highlights
    end

    def archive_highlights!
      Dir.mkdir(clippings_backups_path) unless Dir.exist?(clippings_backups_path)
      backup_name = Time.now.strftime(BACKUP_NAME)
      backup_file_path = File.join(clippings_backups_path, backup_name)
      FileUtils.cp(clippings_path, backup_file_path)
      backup_file_path
    end

    def clear_highlights!
      File.truncate(clippings_path, 0)
    end

    def self.find_at(mount_path)
      volumes = Dir.entries(mount_path) - ['.', '..']

      volumes.map do |name|
        path = File.join(mount_path, name)
        version_path = File.join(path, VERSION_PATH)

        if File.exist?(version_path) && IO.read(version_path) =~ /^Kindle/
          new(path, name)
        end
      end.compact
    end

    private

    def raw_clippings
      File.read(clippings_path).gsub("\r", '')
    end
  end
end
