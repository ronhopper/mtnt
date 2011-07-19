class Lexeme

  attr_accessor :lemma, :pos, :tags, :translation, :gsubs, :etymology, :explanation, :confidence

  def initialize(attributes)
    attributes.each { |k, v| send :"#{k}=", v }
  end

  def to_s
    gsubs = @gsubs.map do |rule|
      "#{rule[0].inspect}#{rule[1]}/#{rule[2] && rule[2].inspect[2..-3]}"
    end.join(' ')
    "#{lemma}|#{pos}|#{tags.join(',')}|#{@translation}|#{gsubs}|#{@etymology}|#{@explanation}|#{@confidence}"
  end

  PARTS_OF_SPEECH = {
    :n => 'noun'
  }

  TAGS = [:feminine, :indeclinable, :masculine, :proper]

end
