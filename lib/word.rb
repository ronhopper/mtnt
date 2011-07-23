# coding: utf-8
class Word

  attr_accessor :id, :position, :form, :lexeme_id, :inflection, :tags, :greek_note, :english_note

  def initialize(id, position, form, lexeme_id, inflection, tags)
    @id = id
    @position = position
    @form = form
    @lexeme_id = lexeme_id
    @inflection = inflection
    @tags = tags
    if note = tags.detect { |tag| tag[0, 6] == 'gnote:' }
      @greek_note = note[6..-1].gsub('+', ' ')
    end
    if note = tags.detect { |tag| tag[0, 6] == 'enote:' }
      @english_note = note[6..-1].gsub('+', ' ')
    end
  end

  def lexeme
    @lexeme ||= Lexicon[lexeme_id] if lexeme_id
  end

  def mt(inf = nil)
    return pt unless lexeme_id
    Inflector.inflect lexeme.translation, lexeme.pos, inf || inflection
  end

  def rmt
    return pt unless lexeme_id
    x = mt(process_inflection_tags)
    process_gsubs! x
    process_post_tags! x
    collapse_affixes! x
    x
  end

private

  def pt
    form.tr ';·', '?;'
  end

  def process_inflection_tags
    if inf = inflection && inflection.dup
      tags.each do |tag|
        case tag
        when /^I[123][sp]$/
          inf[2, 3] = tag.downcase
          tags << '-'
        when 'N'
          inf[0] = 'n'
        end
      end
      inf[1] = 'a' if lexeme.tags.include?(:deponent)
      inf
    end
  end

  def process_gsubs!(x)
    lexeme.gsubs.each do |rule|
      tag, pattern, text, condition = rule
      next unless tag.nil? || tags.include?(tag)
      next unless condition.nil? || inflection =~ condition
      x.gsub! pattern, text
    end
  end

  def process_post_tags!(x)
    tags.each do |tag|
      case tag
      when '-'
        x.sub! /^[a-z>@]+~/, ''
      when /^\+\(.*\)$/
        x << tag.tr('+', ' ')
      when /^\(.*\)\+$/
        x[0, 0] = tag.tr('+', ' ')
      when /^\+".*"$/
        x << tag[2..-2].tr('+', ' ')
      when /^".*"\+$/
        x[0, 0] = tag[1..-3].tr('+', ' ')
      when 'should'
        x.sub! 'might', 'should'
      when 'U'
        x.capitalize!
      end
    end
  end

  def collapse_affixes!(x)
    x.sub! /(^|~| )[>@]~/, '\1'
    x.sub!(/~s(~|$)/, '\1') if [:a, :ra, :rd, :rp, :rr].include?(lexeme.pos)

    x.sub! /([^aeiouy][jsxz])~s(~|$)/, '\1es\2'
    x.sub! /([aeiouy])([jsxz])~s(~|$)/, '\1\2\2es\3'
    x.sub! /~s(~|$)/, 's\1'

    x.sub! /([aeiouy][^aeiouy])e~(ing|ed|er|est)(~|$)/, '\1\2\3'
    x.sub! /(en|er)~(ing|ed|er|est)(~|$)/, '\1\2\3'
    x.sub! /([^aeiouy][aeiouy])([^aeiouwy])~(ing|ed|er|est)(~|$)/, '\1\2\2\3\4'
    x.sub! /~(ing|ed|er|est)(~|$)/, '\1\2'

    x.tr! '~', ' '
  end

end
