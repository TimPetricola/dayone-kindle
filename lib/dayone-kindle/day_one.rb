module DayOne
  def self.journal_location
    @journal_location ||= begin
      prefs_file = File.join(ENV['HOME'], 'Library/Group Containers/5U8NS4GX82.dayoneapp/Data/Preferences/dayone.plist')
      raise 'DayOne preference file not found' unless File.exists?(prefs_file)

      prefs = File.read(prefs_file)
      match = prefs.match(/<key>JournalPackageURL<\/key>\n\t<string>([^<>]+)<\/string>/)
      raise 'DayOne journal not found' unless match && match[1]
      match[1]
    end
  end

  class Entry
    attr_accessor :content, :created_at, :tags

    def initialize(content, options = {})
      @content = content
      @tags = options[:tags] || []
      @created_at = options[:created_at] || Time.now
    end

    def uuid
      @uuid ||= `uuidgen`.gsub('-', '').strip
    end

    def file
      @file ||= File.join(DayOne::journal_location, 'entries', "#{uuid}.doentry")
    end

    def to_xml
      tags_xml = ''

      unless tags.empty?
        tags_xml = <<XML
  <key>Tags</key>
  <array>
  #{tags.map { |tag| "  <string>#{tag}</string>" }.join("\n  ") }
  </array>
XML
      end

      <<-XML
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Creation Date</key>
  <date>#{created_at.utc.iso8601}</date>
  <key>Entry Text</key>
  <string>#{content}</string>
  #{tags_xml.strip}
  <key>UUID</key>
  <string>#{uuid}</string>
</dict>
</plist>
XML
    end

    def save!
      File.open(file, 'w') { |f| f.write(to_xml) }
      uuid
    end
  end
end
