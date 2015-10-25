class DataStore
  attr_reader :entries, :tags

  def initialize(entries, tags = [])
    @entries = entries
    @tags = tags
  end

  def save!
    entries.map { |entry| save_entry!(entry) }
  end

  private

  def save_entry!(entry)
    DayOne::Entry.new(
      entry.to_markdown,
      created_at: entry.time,
      tags: tags
    ).save!
  end
end
