module DayOneKindle
  class Highlight
    attr_reader :book, :highlight, :time, :page, :location, :authors

    def initialize(options)
      # Faking required named arguments for ruby 2.0 compatibility
      %i(book highlight time).each do |param|
        raise ArgumentError, "missing keyword :#{param}" unless options[param]
        instance_variable_set(:"@#{param}", options[param])
      end

      @page = options[:page]
      @location = options[:location]
      @authors = options[:authors] || []
    end

    def to_markdown
      [
        markdown_header,
        '',
        markdown_authors,
        '',
        markdown_highlight,
        '',
        markdown_meta
      ].compact.join("\n")
    end

    private

    def markdown_header
      "# Quote from #{book || 'a book'}"
    end

    def markdown_authors
      return if authors.empty?
      "By #{authors.map { |a| "*#{a}*" }.to_sentence}."
    end

    def markdown_meta
      meta = []
      meta << "Page #{page}" if page
      meta << "Location #{location}" if location
      meta.join(' - ') unless meta.empty?
    end

    def markdown_highlight
      '> ' + highlight.gsub(/\n/, "\n>")
    end
  end
end
