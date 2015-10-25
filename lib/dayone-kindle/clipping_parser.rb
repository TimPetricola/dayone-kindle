module DayOneKindle
  class ClippingParser
    attr_reader :raw

    REGEX = %r{^
      (?<book>.+)\s\((?<authors>.+)\)\n
      \-\s(?<metadata>.+)\n\n
      (?<quote>.+)?
    $}xi

    def initialize(raw)
      @raw = raw
    end

    def highlight
      return unless metadata.match(/Highlight/i)
      return unless quote

      Highlight.new(
        book: book,
        highlight: quote,
        time: time,
        page: page,
        location: location,
        authors: authors
      )
    end

    private

    def book
      @book ||= begin
        b = matches.try(:[], :book)
        b && !b.empty? && b.strip
      end
    end

    def quote
      @quote ||= begin
        q = matches.try(:[], :quote)
        q && !q.empty? && q && q.gsub(/ \u00a0/, "\n\n").strip
      end
    end

    def time
      @time ||= begin
        string = metadata.match(/added on (?<time>.+)/i).try(:[], :time)
        string && !string.empty? && Time.parse(string.strip)
      end
    end

    def page
      @page ||= begin
        page = metadata.match(/page (?<page>\d+)/i).try(:[], :page)
        page && !page.empty? && page.to_i
      end
    end

    def location
      @location ||= begin
        location = metadata.match(/location (?<location>[\d-]+)/i).try(:[], :location)
        location && !location.empty? && location
      end
    end

    def authors
      @authors ||= begin
        string = matches.try(:[], :authors)
        string && !string.empty? && string.split(';')
      end
    end

    def metadata
      @metadata ||= matches[:metadata]
    end

    def matches
      @matches ||= raw.match(REGEX)
    end
  end
end
