# https://github.com/rails/rails/blob/master/activesupport/lib/active_support/core_ext/object/try.rb
class Object
  def try(*a, &b)
    try!(*a, &b) if a.empty? || respond_to?(a.first)
  end

  def try!(*a, &b)
    if a.empty? && block_given?
      if b.arity == 0
        instance_eval(&b)
      else
        yield self
      end
    else
      public_send(*a, &b)
    end
  end
end

# https://github.com/rails/rails/blob/master/activesupport/lib/active_support/core_ext/array/conversions.rb
class Array
  def to_sentence(words_connector: ', ', two_words_connector: ' and ', last_word_connector: ', and ')
    case length
    when 0
      ''
    when 1
      "#{self[0]}"
    when 2
      "#{self[0]}#{two_words_connector}#{self[1]}"
    else
      "#{self[0...-1].join(words_connector)}#{last_word_connector}#{self[-1]}"
    end
  end
end
