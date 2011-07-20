# coding: utf-8
class Word

  attr_accessor :id, :position, :form, :lexeme_id, :inflection, :tags

  def initialize(id, position, form, lexeme_id, inflection, tags)
    @id = id
    @position = position
    @form = form
    @lexeme_id = lexeme_id
    @inflection = inflection
    @tags = tags
  end

  def lexeme
    @lexeme ||= Lexicon[lexeme_id] if lexeme_id
  end

  def mt
    return pt unless lexeme_id
    Inflector.inflect lexeme.translation, lexeme.pos, inflection
  end

  def rmt
    return pt unless lexeme_id
    x = mt
    process_gsubs! x
    process_tags! x
    x.sub! /^[>@]~/, ''
    x.gsub! /~(s|ed|ing|er|est)(~|$)/, '\1\2'
    x.tr '~.', '  '
  end

private

  def pt
    form.tr ';·', '?;'
  end

  def process_gsubs!(x)
    lexeme.gsubs.each do |rule|
      pattern, text, condition = rule
      x.gsub!(pattern, text) if condition.nil? || inflection =~ condition
    end
  end

  def process_tags!(x)
    x.sub!(/^(of|to|>|@)~/, '(the) ') if tags.include?('apposition')
    x.sub!(/^(i|thou|it|we|ye|they)~/, '') if tags.include?('explicit-subject')
    x.sub!(/^(of|to|>)~/, '') if tags.include?('prepositional')
    x[0, 0] = '(of) ' if tags.include?('genitive')
    x << ' (man)' if tags.include?('implicit-man')
    x << ' (woman)' if tags.include?('implicit-woman')
    x.capitalize! if tags.include?('capitalize')
  end

end
