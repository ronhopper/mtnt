module Inflector

  def self.inflect(lemma, pos, inflection)
    case pos
    when :n then inflect_noun(lemma, inflection)
    else "#{lemma}(#{pos})(#{inflection})"
    end
  end

private

  def self.inflect_noun(lemma, inflection)
    inflection ||= 'ns'
    form = case inflection[0]
           when 'n' then "#{lemma}"
           when 'g' then "of~#{lemma}"
           when 'd' then "to~#{lemma}"
           when 'a' then ">~#{lemma}"
           when 'v' then "@~#{lemma}"
           end
    form << '~s' if inflection[1] == 'p'
    form
  end

end
