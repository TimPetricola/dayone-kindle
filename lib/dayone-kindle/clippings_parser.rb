class ClippingsParser
  attr_reader :raw

  def initialize(raw)
    @raw = raw
  end

  def highlights
    raw.split("\n==========\n").map do |r|
      ClippingParser.new(r).highlight
    end.compact
  end
end
