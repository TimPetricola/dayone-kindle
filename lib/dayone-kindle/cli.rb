module DayOneKindle
  module CLI
    def self.dialog(value)
      script = <<-END
  tell app "System Events"
    display dialog "#{value}"
  end tell
END

      system('osascript ' + script.split(/\n/).map { |line| "-e '#{line}'" }.join(' ') + '> /dev/null 2>&1')
    end

    def self.options
      return @options if @options

      options = {
        ask_confirmation: true,
        tags: [],
        dry_run: false,
        archive: true
      }

      optparse = OptionParser.new do |opts|
        opts.banner = 'Usage: dayone-kindle [options]'

        opts.on '--dry', 'Outputs highlights instead of importing them (use for testing)' do
          options[:dry_run] = true
        end

        opts.on '-t', '--tags reading,quote', Array, 'Tags to be saved with highlights' do |t|
          options[:tags] = t
        end

        opts.on '--auto-confirm', 'Do not ask for confirmation before import' do
          options[:ask_confirmation] = false
        end

        opts.on '--no-archive', 'Do not archive imported highlights on device' do
          options[:archive] = false
        end
      end

      optparse.parse!

      @options = options
    end

    def self.run
      tags = options[:tags]

      DayOneKindle::Device.find_at('/Volumes').each do |kindle|
        next if kindle.highlights.empty?

        if options[:ask_confirmation]
          label = "#{kindle.name} detected. Highlights will be imported to Day One."
          next unless dialog(label)
        end

        store = DayOneKindle::DataStore.new(kindle.highlights, tags)
        puts "#{store.entries.count} highlights to import"

        puts "Tags: #{tags.empty? ? 'no tags' : tags.join(', ')}"

        if options[:dry_run]
          puts 'Dry run, no highlight imported'
        else
          entries = store.save!
          puts "#{entries.count} highlights imported with tags"

          if options[:archive]
            path = kindle.archive_highlights!
            puts "Highlights archived at #{path}"
          end

          kindle.clear_highlights!
          puts 'Highlights cleared from device'
        end
      end
    end
  end
end
