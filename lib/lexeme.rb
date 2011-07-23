class Lexeme

  attr_accessor :lemma, :pos, :tags, :translation, :gsubs, :etymology, :explanation, :quality

  def initialize(attributes)
    attributes.each { |k, v| send :"#{k}=", v }
  end

  def closed?
    [:ra, :c, :rd, :p, :rp, :rr, :x].include? pos
  end

  def gsubs_to_s
    @gsubs.map do |rule|
      "#{rule[0]}#{rule[1].inspect}#{rule[2]}/#{rule[3].inspect[2..-3]}".tr('|', '!')
    end.join(' ')
  end

  def to_s
    "#{lemma}|#{pos}|#{tags.join(',')}|#{@translation}|#{gsubs_to_s}|#{@etymology}|#{@explanation}|#{closed? ? nil : @quality.join(',')}"
  end

  PARTS_OF_SPEECH = {
    :a  => 'adjective',
    :d  => 'adverb',
    :ra => 'article',
    :c  => 'conjunction',
    :rd => 'demonstrative pronoun',
    :x  => 'exclamation',
    :n  => 'noun',
    :p  => 'preposition',
    :rp => 'personal pronoun',
    :rr => 'relative pronoun',
    :v  => 'verb'
  }

  TAGS = [:deponent, :feminine, :indeclinable, :masculine, :neuter, :proper]

end
