# coding: utf-8
class Formatter

  def initialize(words)
    @words = words
  end

  def greek
    html = ['']
    @words.each do |word|
      if word.lexeme
        hover = [word.lexeme_id, word.inflection].compact.join(' + ')
        html << %{<a href="/#{word.lexeme_id}" title="#{hover}" class="word-#{word.id}">#{word.form}</a>}
        if word.greek_note
          html[-1] << %{<sub class="note">[<a title="#{word.greek_note}">NOTE</a>]</sub>}
        end
      elsif word.form == '“'
        html << '<q>'
      elsif word.form == '”'
        html[-1] << '</q>'
      else
        html[-1] << word.form
      end
    end
    html.reject { |s| s == '' }.join(' ').gsub('<q> ','<q>')
  end

  def mt
    html = ['']
    @words.each do |word|
      xlation, meaning = word.mt.split(/[\[\]]/)
      if word.lexeme
        classes = (["word-#{word.id}", word.inflection] + word.lexeme.tags).compact
        html << %{<a href="/#{word.lexeme_id}" title="#{lexeme_hover(word.lexeme)}" class="#{classes.join(' ')}">#{xlation}</a>}
        if meaning
          html[-1] << %{<sup>&nbsp;[#{meaning.gsub(' ', '&nbsp;')}]</sup>}
        end
        if word.english_note
          html[-1] << %{<sub class="note">[<a title="#{word.english_note}">NOTE</a>]</sub>}
        end
      elsif word.form == '“'
        html << '<q>'
      elsif word.form == '”'
        html[-1] << '</q>'
      else
        html[-1] << xlation
      end
    end
    html.reject { |s| s == '' }.join(' ').gsub('<q> ','<q>')
  end

  def rmt
    html = ['']
    diwords = @words.reject { |w| w.position == 0 }.sort_by(&:position).map { |word| [word, word.rmt] }
    process_tags! diwords
    diwords.each do |diword|
      if diword[0].respond_to?(:lexeme)
        word = diword[0]
        xlation, meaning = diword[1].split(/[\[\]]/)
        if word.lexeme
          classes = (["word-#{word.id}", word.inflection] + word.lexeme.tags).compact
          html << %{<a href="/#{word.lexeme_id}" title="#{lexeme_hover(word.lexeme)}" class="#{classes.join(' ')}">#{xlation}</a>}
          if meaning
            html[-1] << %{<sup>&nbsp;[#{meaning.gsub(' ', '&nbsp;')}]</sup>}
          end
          if word.english_note
            html[-1] << %{<sub class="note">[<a title="#{word.english_note}">NOTE</a>]</sub>}
          end
        elsif word.form == '“'
          html << '<q>'
        elsif word.form == '”'
          html[-1] << '</q>'
        else
          html[-1] << xlation
        end
      else
        html << %{<span class="implicit">(#{diword})</span>}
      end
    end
    html.reject { |s| s == '' }.join(' ').gsub('<q> ','<q>')
  end

private

  def lexeme_hover(l)
    "#{l.lemma} &mdash; #{l.translation} &mdash; #{l.explanation.gsub('"', '&quot;')}"
  end

  def process_tags!(diwords)
    offset = 0
    diwords.dup.each_with_index do |diword, i|
      diword[0].tags.each do |tag|
        case tag
        when /^\+\[.*\]$/
          diwords[i + offset + 1, 0] = tag[2..-2].tr('+', ' ')
          offset += 1
        when /^\[.*\]\+$/
          diwords[i + offset, 0] = tag[1..-3].tr('+', ' ')
          offset += 1
        when /^>+$/
          diwords[i + offset, 0] = [remove_prefix!(diwords[i + offset + 1], tag.length)]
          offset += 1
        end
      end
    end
  end

  def remove_prefix!(diword, count)
    word, xlation = *diword
    prefix = xlation.split(' ')[0, count].join(' ')
    diword[1] = xlation[(prefix.length + 1)..-1].strip
    [word, prefix]
  end

end
