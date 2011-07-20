module Inflector

  def self.inflect(lemma, pos, inflection)
    case pos
    when :n, :ra, :rp then inflect_noun(lemma, inflection)
    when :c then lemma.dup
    when :v then inflect_verb(lemma, inflection)
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

  def self.inflect_verb(lemma, inflection)
    inflection = normalize_verb(inflection)
    case inflection[2]
    when 'i' then inflect_verb_indicative(lemma, inflection[0, 2], inflection[3, 2])
    when 'p' then inflect_verb_participle(lemma, inflection[0, 2], inflection[3, 3])
    when 'n' then inflect_verb_infinitive(lemma, inflection[0, 2])
    else "#{lemma}(v)(#{inflection})"
    end
  end

  def self.normalize_verb(inflection)
    inflection ||= ''
    inflection = inflection.dup
    inflection[0] = inflection[0].tr('uoec', 'farl') if inflection.length > 0
    inflection[1] = inflection[1].tr('don', 'aaa') if inflection.length > 1
    inflection
  end

  def self.inflect_verb_indicative(lemma, tv, pn)
    prefix = {
      '1s' => 'i',    '1p' => 'we',
      '2s' => 'thou', '2p' => 'ye',
      '3s' => 'it',   '3p' => 'they'
    }[pn]
    middle = {
      '1s' => 'for~myself',  '1p' => 'for~ourselves',
      '2s' => 'for~thyself', '2p' => 'for~yourselves',
      '3s' => 'for~itself',  '3p' => 'for~themselves'
    }[pn] if tv[1] == 'm'
    helper, suffix = {
      'pa' => [nil, pn =~ /[23]s/ ? 's' : nil],       'pp' => [pn[1] == 's' ? (pn[0] == '1' ? 'am' : 'is') : 'are', 'ed'],
      'ia' => [pn[1] == 's' ? 'was' : 'were', 'ing'], 'ip' => [pn[1] == 's' ? 'was~being' : 'were~being', 'ed'],
      'fa' => ['will', nil],                          'fp' => ['will~be', 'ed'],
      'aa' => [nil, 'ed'],                            'ap' => [pn[1] == 's' ? 'was' : 'were', 'ed'],
      'ra' => [pn =~ /[23]s/ ? 'has' : 'have', 'ed'], 'rp' => [pn =~ /[23]s/ ? 'has~been' : 'have~been', 'ed'],
      'la' => ['had', 'ed'],                          'lp' => ['had~been', 'ed']
    }[tv.sub('m', 'a')]
    [prefix, helper, lemma, suffix, middle].compact.join('~')
  end

  def self.inflect_verb_participle(lemma, tv, cng)
    if tv[0] != 'p'
      return "#{lemma}(#{tv}p#{cng})"
    end
    middle = 'for~self' if tv[1] == 'm'
    helper, suffix = {
      'pa' => [nil, 'ing'], 'pp' => ['being', 'ed']
    }[tv.sub('m', 'a')]
    form = [helper, lemma, suffix, middle].compact.join('~')
    inflect_noun form, cng
  end

  def self.inflect_verb_infinitive(lemma, tv)
    middle = 'for~oneself' if tv[1] == 'm'
    helper, suffix = {
      'pa' => [nil, 'ongoing'],     'pp' => ['be', 'ed~ongoing'],
      'fa' => ['be~about~to', nil], 'fp' => ['be~about~to~be', 'ed'],
      'aa' => [nil, nil],           'ap' => ['be', 'ed'],
      'ra' => ['have', 'ed'],       'rp' => ['have~been', 'ed']
    }[tv.sub('m', 'a')]
    ['to', helper, lemma, suffix, middle].compact.join('~')
  end

end
