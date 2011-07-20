class Lexeme

  attr_accessor :lemma, :pos, :tags, :translation, :gsubs, :etymology, :explanation, :confidence

  def initialize(attributes)
    attributes.each { |k, v| send :"#{k}=", v }
  end

  def gsubs_to_s
    @gsubs.map do |rule|
      "#{rule[0].inspect}#{rule[1]}/#{rule[2].inspect[2..-3]}"
    end.join(' ')
  end

  def to_s
    "#{lemma}|#{pos}|#{tags.join(',')}|#{@translation}|#{gsubs_to_s}|#{@etymology}|#{@explanation}|#{@confidence}"
  end

  PARTS_OF_SPEECH = {
    :ra => 'article',
    :c  => 'conjunction',
    :n  => 'noun',
    :rp => 'pronoun',
    :v  => 'verb'
  }

  TAGS = [:feminine, :indeclinable, :masculine, :proper]

end
