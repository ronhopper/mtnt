module Inflector

  def self.inflect(lemma, pos, inflection)
    case pos
    when :n, :a, :ra, :rp, :rr then inflect_noun(lemma, inflection)
    when :c, :p then lemma.dup
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
    when 's' then inflect_verb_conjunctive(lemma, inflection[0, 3], inflection[3, 2])
    when 'o' then inflect_verb_conjunctive(lemma, inflection[0, 3], inflection[3, 2])
    when 'm' then inflect_verb_imperative(lemma, inflection[0, 2], inflection[3, 2])
    when 'n' then inflect_verb_infinitive(lemma, inflection[0, 2])
    when 'p' then inflect_verb_participle(lemma, inflection[0, 2], inflection[3, 3])
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

  def self.inflect_verb_conjunctive(lemma, tvm, pn)
    prefix = {
      '1s' => 'i',    '1p' => 'we',
      '2s' => 'thou', '2p' => 'ye',
      '3s' => 'it',   '3p' => 'they'
    }[pn]
    middle = {
      '1s' => 'for~myself',  '1p' => 'for~ourselves',
      '2s' => 'for~thyself', '2p' => 'for~yourselves',
      '3s' => 'for~itself',  '3p' => 'for~themselves'
    }[pn] if tvm[1] == 'm'
    conjunctive = { 's' => 'might', 'o' => 'would' }[tvm[2]]
    helper, suffix = {
      'pa' => ['continue~to', nil], 'pp' => ['continue~to~be', 'ed'],
      'aa' => [nil, nil],           'ap' => ['be', 'ed']
    }[tvm[0, 2].sub('m', 'a')]
    [prefix, conjunctive, helper, lemma, suffix, middle].compact.join('~')
  end

  def self.inflect_verb_imperative(lemma, tv, pn)
    middle = {
      '2s' => 'for~thyself', '2p' => 'for~yourselves',
      '3s' => 'for~itself',  '3p' => 'for~themselves'
    }[pn] if tv[1] == 'm'
    prefix, suffix = {
      'pa2s' => ['continue~thou~to', nil],      'pa2p' => ['continue~ye~to', nil],
      'pa3s' => ['let~it~continue~to', nil],    'pa3p' => ['let~them~continue~to', nil],
      'aa2s' => [nil, 'thou'],                  'aa2p' => [nil, 'ye'],
      'aa3s' => ['let~it', nil],                'aa3p' => ['let~them', nil],
      'ra2s' => ['let~thou~have', 'ed'],        'ra2p' => ['let~ye~have', 'ed'],
      'ra3s' => ['let~it~have', 'ed'],          'ra3p' => ['let~them~have', 'ed'],
      'pp2s' => ['continue~thou~to~be', 'ed'],  'pp2p' => ['continue~ye~to~be', 'ed'],
      'pp3s' => ['be~it', 'ed'],                'pp3p' => ['be~they', 'ed'],
      'ap2s' => ['be~thou', 'ed'],              'ap2p' => ['be~ye', 'ed'],
      'ap3s' => ['be~it', 'ed'],                'ap3p' => ['be~they', 'ed'],
      'rp2s' => ['let~thou~have~been', 'ed'],   'rp2p' => ['let~ye~have~been', 'ed'],
      'rp3s' => ['let~it~have~been', 'ed'],     'rp3p' => ['let~them~have~been', 'ed']
    }[tv.sub('m', 'a') + pn]
    [prefix, lemma, suffix, middle].compact.join('~')
  end

  def self.inflect_verb_infinitive(lemma, tv)
    middle = 'for~oneself' if tv[1] == 'm'
    helper, suffix = {
      'pa' => ['continue~to', nil], 'pp' => ['continue~to~be', 'ed'],
      'fa' => ['be~about~to', nil], 'fp' => ['be~about~to~be', 'ed'],
      'aa' => [nil, nil],           'ap' => ['be', 'ed'],
      'ra' => ['have', 'ed'],       'rp' => ['have~been', 'ed']
    }[tv.sub('m', 'a')]
    ['to', helper, lemma, suffix, middle].compact.join('~')
  end

  def self.inflect_verb_participle(lemma, tv, cng)
    middle = 'for~self' if tv[1] == 'm'
    helper, suffix = {
      'pa' => [nil, 'ing'],             'pp' => ['being', 'ed'],
      'fa' => ['being~about~to', nil],  'fp' => ['being~about~to~be', 'ed'],
      'aa' => ['having', 'ed'],         'ap' => [nil, 'ed'],
      'ra' => ['already~having', 'ed'], 'rp' => ['already', 'ed']
    }[tv.sub('m', 'a')]
    form = [helper, lemma, suffix, middle].compact.join('~')
    inflect_noun form, cng
  end

end
