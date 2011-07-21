require './lib/inflector'

describe Inflector do

  NOUN_EXAMPLES = {
    'ns' => 'BOOK',    'np' => 'BOOK~s',
    'gs' => 'of~BOOK', 'gp' => 'of~BOOK~s',
    'ds' => 'to~BOOK', 'dp' => 'to~BOOK~s',
    'as' => '>~BOOK',  'ap' => '>~BOOK~s',
    'vs' => '@~BOOK',  'vp' => '@~BOOK~s'
  }

  ARTICLE_EXAMPLES = {
    'nsm' => 'THE',    'npm' => 'THE~s',
    'gsm' => 'of~THE', 'gpm' => 'of~THE~s',
    'dsm' => 'to~THE', 'dpm' => 'to~THE~s',
    'asm' => '>~THE',  'apm' => '>~THE~s'
  }

  # add all genders
  ARTICLE_EXAMPLES.dup.each do |inflection, form|
    %w[f n].each do |g|
      inflection2 = inflection.dup
      inflection2[2] = g
      ARTICLE_EXAMPLES[inflection2] = form
    end
  end

  PERSONAL_PRONOUN_EXAMPLES = {
    'nsm' => 'IT',    'npm' => 'IT~s',
    'gsm' => 'of~IT', 'gpm' => 'of~IT~s',
    'dsm' => 'to~IT', 'dpm' => 'to~IT~s',
    'asm' => '>~IT',  'apm' => '>~IT~s'
  }

  # add all genders
  PERSONAL_PRONOUN_EXAMPLES.dup.each do |inflection, form|
    %w[f n].each do |g|
      inflection2 = inflection.dup
      inflection2[2] = g
      PERSONAL_PRONOUN_EXAMPLES[inflection2] = form
    end
  end

  RELATIVE_PRONOUN_EXAMPLES = {
    'nsm' => 'WHO',    'npm' => 'WHO~s',
    'gsm' => 'of~WHO', 'gpm' => 'of~WHO~s',
    'dsm' => 'to~WHO', 'dpm' => 'to~WHO~s',
    'asm' => '>~WHO',  'apm' => '>~WHO~s'
  }

  # add all genders
  RELATIVE_PRONOUN_EXAMPLES.dup.each do |inflection, form|
    %w[f n].each do |g|
      inflection2 = inflection.dup
      inflection2[2] = g
      RELATIVE_PRONOUN_EXAMPLES[inflection2] = form
    end
  end

  VERB_EXAMPLES = {
    'pai1s' => 'i~HEAL',                        'pai1p' => 'we~HEAL',
    'pai2s' => 'thou~HEAL~s',                   'pai2p' => 'ye~HEAL',
    'pai3s' => 'it~HEAL~s',                     'pai3p' => 'they~HEAL',
    'iai1s' => 'i~was~HEAL~ing',                'iai1p' => 'we~were~HEAL~ing',
    'iai2s' => 'thou~was~HEAL~ing',             'iai2p' => 'ye~were~HEAL~ing',
    'iai3s' => 'it~was~HEAL~ing',               'iai3p' => 'they~were~HEAL~ing',
    'fai1s' => 'i~will~HEAL',                   'fai1p' => 'we~will~HEAL',
    'fai2s' => 'thou~will~HEAL',                'fai2p' => 'ye~will~HEAL',
    'fai3s' => 'it~will~HEAL',                  'fai3p' => 'they~will~HEAL',
    'aai1s' => 'i~HEAL~ed',                     'aai1p' => 'we~HEAL~ed',
    'aai2s' => 'thou~HEAL~ed',                  'aai2p' => 'ye~HEAL~ed',
    'aai3s' => 'it~HEAL~ed',                    'aai3p' => 'they~HEAL~ed',
    'rai1s' => 'i~have~HEAL~ed',                'rai1p' => 'we~have~HEAL~ed',
    'rai2s' => 'thou~has~HEAL~ed',              'rai2p' => 'ye~have~HEAL~ed',
    'rai3s' => 'it~has~HEAL~ed',                'rai3p' => 'they~have~HEAL~ed',
    'lai1s' => 'i~had~HEAL~ed',                 'lai1p' => 'we~had~HEAL~ed',
    'lai2s' => 'thou~had~HEAL~ed',              'lai2p' => 'ye~had~HEAL~ed',
    'lai3s' => 'it~had~HEAL~ed',                'lai3p' => 'they~had~HEAL~ed',

    'pmi1s' => 'i~HEAL~for~myself',             'pmi1p' => 'we~HEAL~for~ourselves',
    'pmi2s' => 'thou~HEAL~s~for~thyself',       'pmi2p' => 'ye~HEAL~for~yourselves',
    'pmi3s' => 'it~HEAL~s~for~itself',          'pmi3p' => 'they~HEAL~for~themselves',
    'imi1s' => 'i~was~HEAL~ing~for~myself',     'imi1p' => 'we~were~HEAL~ing~for~ourselves',
    'imi2s' => 'thou~was~HEAL~ing~for~thyself', 'imi2p' => 'ye~were~HEAL~ing~for~yourselves',
    'imi3s' => 'it~was~HEAL~ing~for~itself',    'imi3p' => 'they~were~HEAL~ing~for~themselves',
    'fmi1s' => 'i~will~HEAL~for~myself',        'fmi1p' => 'we~will~HEAL~for~ourselves',
    'fmi2s' => 'thou~will~HEAL~for~thyself',    'fmi2p' => 'ye~will~HEAL~for~yourselves',
    'fmi3s' => 'it~will~HEAL~for~itself',       'fmi3p' => 'they~will~HEAL~for~themselves',
    'ami1s' => 'i~HEAL~ed~for~myself',          'ami1p' => 'we~HEAL~ed~for~ourselves',
    'ami2s' => 'thou~HEAL~ed~for~thyself',      'ami2p' => 'ye~HEAL~ed~for~yourselves',
    'ami3s' => 'it~HEAL~ed~for~itself',         'ami3p' => 'they~HEAL~ed~for~themselves',
    'rmi1s' => 'i~have~HEAL~ed~for~myself',     'rmi1p' => 'we~have~HEAL~ed~for~ourselves',
    'rmi2s' => 'thou~has~HEAL~ed~for~thyself',  'rmi2p' => 'ye~have~HEAL~ed~for~yourselves',
    'rmi3s' => 'it~has~HEAL~ed~for~itself',     'rmi3p' => 'they~have~HEAL~ed~for~themselves',
    'lmi1s' => 'i~had~HEAL~ed~for~myself',      'lmi1p' => 'we~had~HEAL~ed~for~ourselves',
    'lmi2s' => 'thou~had~HEAL~ed~for~thyself',  'lmi2p' => 'ye~had~HEAL~ed~for~yourselves',
    'lmi3s' => 'it~had~HEAL~ed~for~itself',     'lmi3p' => 'they~had~HEAL~ed~for~themselves',

    'ppi1s' => 'i~am~HEAL~ed',                  'ppi1p' => 'we~are~HEAL~ed',
    'ppi2s' => 'thou~is~HEAL~ed',               'ppi2p' => 'ye~are~HEAL~ed',
    'ppi3s' => 'it~is~HEAL~ed',                 'ppi3p' => 'they~are~HEAL~ed',
    'ipi1s' => 'i~was~being~HEAL~ed',           'ipi1p' => 'we~were~being~HEAL~ed',
    'ipi2s' => 'thou~was~being~HEAL~ed',        'ipi2p' => 'ye~were~being~HEAL~ed',
    'ipi3s' => 'it~was~being~HEAL~ed',          'ipi3p' => 'they~were~being~HEAL~ed',
    'fpi1s' => 'i~will~be~HEAL~ed',             'fpi1p' => 'we~will~be~HEAL~ed',
    'fpi2s' => 'thou~will~be~HEAL~ed',          'fpi2p' => 'ye~will~be~HEAL~ed',
    'fpi3s' => 'it~will~be~HEAL~ed',            'fpi3p' => 'they~will~be~HEAL~ed',
    'api1s' => 'i~was~HEAL~ed',                 'api1p' => 'we~were~HEAL~ed',
    'api2s' => 'thou~was~HEAL~ed',              'api2p' => 'ye~were~HEAL~ed',
    'api3s' => 'it~was~HEAL~ed',                'api3p' => 'they~were~HEAL~ed',
    'rpi1s' => 'i~have~been~HEAL~ed',           'rpi1p' => 'we~have~been~HEAL~ed',
    'rpi2s' => 'thou~has~been~HEAL~ed',         'rpi2p' => 'ye~have~been~HEAL~ed',
    'rpi3s' => 'it~has~been~HEAL~ed',           'rpi3p' => 'they~have~been~HEAL~ed',
    'lpi1s' => 'i~had~been~HEAL~ed',            'lpi1p' => 'we~had~been~HEAL~ed',
    'lpi2s' => 'thou~had~been~HEAL~ed',         'lpi2p' => 'ye~had~been~HEAL~ed',
    'lpi3s' => 'it~had~been~HEAL~ed',           'lpi3p' => 'they~had~been~HEAL~ed',

    'papnsm' => 'HEAL~ing',                     'papgpf' => 'of~HEAL~ing~s',
    'pmpnsm' => 'HEAL~ing~for~self',            'pmpgpf' => 'of~HEAL~ing~for~self~s',
    'pppnsm' => 'being~HEAL~ed',                'pppgpf' => 'of~being~HEAL~ed~s',

    'pan' => 'to~HEAL~ongoing',     'pmn' => 'to~HEAL~ongoing~for~oneself',     'ppn' => 'to~be~HEAL~ed~ongoing',
    'fan' => 'to~be~about~to~HEAL', 'fmn' => 'to~be~about~to~HEAL~for~oneself', 'fpn' => 'to~be~about~to~be~HEAL~ed',
    'aan' => 'to~HEAL',             'amn' => 'to~HEAL~for~oneself',             'apn' => 'to~be~HEAL~ed',
    'ran' => 'to~have~HEAL~ed',     'rmn' => 'to~have~HEAL~ed~for~oneself',     'rpn' => 'to~have~been~HEAL~ed'
  }

  # add strong-future, strong-aorist, strong-perfect, strong-pluperfect
  VERB_EXAMPLES.dup.each do |inflection, form|
    if 'farl'.include?(inflection[0])
      inflection2 = inflection.dup
      inflection2[0] = inflection[0].tr 'farl', 'uoec'
      VERB_EXAMPLES[inflection2] = form
    end
  end

  # add deponents
  VERB_EXAMPLES.dup.each do |inflection, form|
    if 'a' == inflection[1]
      %w[d o n].each do |v|
        inflection2 = inflection.dup
        inflection2[1] = v
        VERB_EXAMPLES[inflection2] = form
      end
    end
  end

  NOUN_EXAMPLES.each do |inflection, form|
    it "inflects the noun 'BOOK'+#{inflection}" do
      Inflector.inflect('BOOK', :n, inflection).should == form
    end
  end

  ARTICLE_EXAMPLES.each do |inflection, form|
    it "inflects the article 'THE'+#{inflection}" do
      Inflector.inflect('THE', :ra, inflection).should == form
    end
  end

  PERSONAL_PRONOUN_EXAMPLES.each do |inflection, form|
    it "inflects the personal pronoun 'IT'+#{inflection}" do
      Inflector.inflect('IT', :rp, inflection).should == form
    end
  end

  RELATIVE_PRONOUN_EXAMPLES.each do |inflection, form|
    it "inflects the relative pronoun 'WHO'+#{inflection}" do
      Inflector.inflect('WHO', :rr, inflection).should == form
    end
  end

  VERB_EXAMPLES.each do |inflection, form|
    it "inflects the verb 'HEAl'+#{inflection}" do
      Inflector.inflect('HEAL', :v, inflection).should == form
    end
  end

  it "inflects the conjunction 'AND'" do
    Inflector.inflect('AND', :c, nil).should == 'AND'
  end

  it "inflects the preposition 'FROM'" do
    Inflector.inflect('FROM', :p, nil).should == 'FROM'
  end

  it "outputs debugging info for unknown inflections" do
    Inflector.inflect('FOO', :qq, 'bar').should == 'FOO(qq)(bar)'
  end

end
