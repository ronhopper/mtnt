require './lib/inflector'

describe Inflector do

  NOUN_EXAMPLES = {
    'ns' => 'BOOK',    'np' => 'BOOK~s',
    'gs' => 'of~BOOK', 'gp' => 'of~BOOK~s',
    'ds' => 'to~BOOK', 'dp' => 'to~BOOK~s',
    'as' => '>~BOOK',  'ap' => '>~BOOK~s',
    'vs' => '@~BOOK',  'vp' => '@~BOOK~s'
  }

  ADJECTIVE_EXAMPLES = {
    'nsm' => 'BIG',    'npm' => 'BIG~s',
    'gsm' => 'of~BIG', 'gpm' => 'of~BIG~s',
    'dsm' => 'to~BIG', 'dpm' => 'to~BIG~s',
    'asm' => '>~BIG',  'apm' => '>~BIG~s',
    'vsm' => '@~BIG',  'vpm' => '@~BIG~s'
  }

  # add all genders
  ADJECTIVE_EXAMPLES.dup.each do |inflection, form|
    %w[f n].each do |g|
      inflection2 = inflection.dup
      inflection2[2] = g
      ADJECTIVE_EXAMPLES[inflection2] = form
    end
  end

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

    'pam2s' => 'continue~thou~to~HEAL',               'pam2p' => 'continue~ye~to~HEAL',
    'pam3s' => 'let~it~continue~to~HEAL',             'pam3p' => 'let~them~continue~to~HEAL',
    'aam2s' => 'HEAL~thou',                           'aam2p' => 'HEAL~ye',
    'aam3s' => 'let~it~HEAL',                         'aam3p' => 'let~them~HEAL',
    'ram2s' => 'let~thou~have~HEAL~ed',               'ram2p' => 'let~ye~have~HEAL~ed',
    'ram3s' => 'let~it~have~HEAL~ed',                 'ram3p' => 'let~them~have~HEAL~ed',

    'pmm2s' => 'continue~thou~to~HEAL~for~thyself',   'pmm2p' => 'continue~ye~to~HEAL~for~yourselves',
    'pmm3s' => 'let~it~continue~to~HEAL~for~itself',  'pmm3p' => 'let~them~continue~to~HEAL~for~themselves',
    'amm2s' => 'HEAL~thou~for~thyself',               'amm2p' => 'HEAL~ye~for~yourselves',
    'amm3s' => 'let~it~HEAL~for~itself',              'amm3p' => 'let~them~HEAL~for~themselves',
    'rmm2s' => 'let~thou~have~HEAL~ed~for~thyself',   'rmm2p' => 'let~ye~have~HEAL~ed~for~yourselves',
    'rmm3s' => 'let~it~have~HEAL~ed~for~itself',      'rmm3p' => 'let~them~have~HEAL~ed~for~themselves',

    'ppm2s' => 'continue~thou~to~be~HEAL~ed',         'ppm2p' => 'continue~ye~to~be~HEAL~ed',
    'ppm3s' => 'be~it~HEAL~ed',                       'ppm3p' => 'be~they~HEAL~ed',
    'apm2s' => 'be~thou~HEAL~ed',                     'apm2p' => 'be~ye~HEAL~ed',
    'apm3s' => 'be~it~HEAL~ed',                       'apm3p' => 'be~they~HEAL~ed',
    'rpm2s' => 'let~thou~have~been~HEAL~ed',          'rpm2p' => 'let~ye~have~been~HEAL~ed',
    'rpm3s' => 'let~it~have~been~HEAL~ed',            'rpm3p' => 'let~them~have~been~HEAL~ed',

    'pas1s' => 'i~might~continue~to~HEAL',                'pas1p' => 'we~might~continue~to~HEAL',
    'pas2s' => 'thou~might~continue~to~HEAL',             'pas2p' => 'ye~might~continue~to~HEAL',
    'pas3s' => 'it~might~continue~to~HEAL',               'pas3p' => 'they~might~continue~to~HEAL',
    'aas1s' => 'i~might~HEAL',                            'aas1p' => 'we~might~HEAL',
    'aas2s' => 'thou~might~HEAL',                         'aas2p' => 'ye~might~HEAL',
    'aas3s' => 'it~might~HEAL',                           'aas3p' => 'they~might~HEAL',

    'pms1s' => 'i~might~continue~to~HEAL~for~myself',     'pms1p' => 'we~might~continue~to~HEAL~for~ourselves',
    'pms2s' => 'thou~might~continue~to~HEAL~for~thyself', 'pms2p' => 'ye~might~continue~to~HEAL~for~yourselves',
    'pms3s' => 'it~might~continue~to~HEAL~for~itself',    'pms3p' => 'they~might~continue~to~HEAL~for~themselves',
    'ams1s' => 'i~might~HEAL~for~myself',                 'ams1p' => 'we~might~HEAL~for~ourselves',
    'ams2s' => 'thou~might~HEAL~for~thyself',             'ams2p' => 'ye~might~HEAL~for~yourselves',
    'ams3s' => 'it~might~HEAL~for~itself',                'ams3p' => 'they~might~HEAL~for~themselves',

    'pps1s' => 'i~might~continue~to~be~HEAL~ed',          'pps1p' => 'we~might~continue~to~be~HEAL~ed',
    'pps2s' => 'thou~might~continue~to~be~HEAL~ed',       'pps2p' => 'ye~might~continue~to~be~HEAL~ed',
    'pps3s' => 'it~might~continue~to~be~HEAL~ed',         'pps3p' => 'they~might~continue~to~be~HEAL~ed',
    'aps1s' => 'i~might~be~HEAL~ed',                      'aps1p' => 'we~might~be~HEAL~ed',
    'aps2s' => 'thou~might~be~HEAL~ed',                   'aps2p' => 'ye~might~be~HEAL~ed',
    'aps3s' => 'it~might~be~HEAL~ed',                     'aps3p' => 'they~might~be~HEAL~ed',

    'pao1s' => 'i~would~continue~to~HEAL',                'pao1p' => 'we~would~continue~to~HEAL',
    'pao2s' => 'thou~would~continue~to~HEAL',             'pao2p' => 'ye~would~continue~to~HEAL',
    'pao3s' => 'it~would~continue~to~HEAL',               'pao3p' => 'they~would~continue~to~HEAL',
    'aao1s' => 'i~would~HEAL',                            'aao1p' => 'we~would~HEAL',
    'aao2s' => 'thou~would~HEAL',                         'aao2p' => 'ye~would~HEAL',
    'aao3s' => 'it~would~HEAL',                           'aao3p' => 'they~would~HEAL',

    'pmo1s' => 'i~would~continue~to~HEAL~for~myself',     'pmo1p' => 'we~would~continue~to~HEAL~for~ourselves',
    'pmo2s' => 'thou~would~continue~to~HEAL~for~thyself', 'pmo2p' => 'ye~would~continue~to~HEAL~for~yourselves',
    'pmo3s' => 'it~would~continue~to~HEAL~for~itself',    'pmo3p' => 'they~would~continue~to~HEAL~for~themselves',
    'amo1s' => 'i~would~HEAL~for~myself',                 'amo1p' => 'we~would~HEAL~for~ourselves',
    'amo2s' => 'thou~would~HEAL~for~thyself',             'amo2p' => 'ye~would~HEAL~for~yourselves',
    'amo3s' => 'it~would~HEAL~for~itself',                'amo3p' => 'they~would~HEAL~for~themselves',

    'ppo1s' => 'i~would~continue~to~be~HEAL~ed',          'ppo1p' => 'we~would~continue~to~be~HEAL~ed',
    'ppo2s' => 'thou~would~continue~to~be~HEAL~ed',       'ppo2p' => 'ye~would~continue~to~be~HEAL~ed',
    'ppo3s' => 'it~would~continue~to~be~HEAL~ed',         'ppo3p' => 'they~would~continue~to~be~HEAL~ed',
    'apo1s' => 'i~would~be~HEAL~ed',                      'apo1p' => 'we~would~be~HEAL~ed',
    'apo2s' => 'thou~would~be~HEAL~ed',                   'apo2p' => 'ye~would~be~HEAL~ed',
    'apo3s' => 'it~would~be~HEAL~ed',                     'apo3p' => 'they~would~be~HEAL~ed',

    'pan' => 'to~continue~to~HEAL', 'pmn' => 'to~continue~to~HEAL~for~oneself', 'ppn' => 'to~continue~to~be~HEAL~ed',
    'fan' => 'to~be~about~to~HEAL', 'fmn' => 'to~be~about~to~HEAL~for~oneself', 'fpn' => 'to~be~about~to~be~HEAL~ed',
    'aan' => 'to~HEAL',             'amn' => 'to~HEAL~for~oneself',             'apn' => 'to~be~HEAL~ed',
    'ran' => 'to~have~HEAL~ed',     'rmn' => 'to~have~HEAL~ed~for~oneself',     'rpn' => 'to~have~been~HEAL~ed',

    'papnsm' => 'HEAL~ing',                         'papgpf' => 'of~HEAL~ing~s',
    'pmpnsm' => 'HEAL~ing~for~self',                'pmpgpf' => 'of~HEAL~ing~for~self~s',
    'pppnsm' => 'being~HEAL~ed',                    'pppgpf' => 'of~being~HEAL~ed~s',
    'fapnsm' => 'being~about~to~HEAL',              'fapgpf' => 'of~being~about~to~HEAL~s',
    'fmpnsm' => 'being~about~to~HEAL~for~self',     'fmpgpf' => 'of~being~about~to~HEAL~for~self~s',
    'fppnsm' => 'being~about~to~be~HEAL~ed',        'fppgpf' => 'of~being~about~to~be~HEAL~ed~s',
    'aapnsm' => 'having~HEAL~ed',                   'aapgpf' => 'of~having~HEAL~ed~s',
    'ampnsm' => 'having~HEAL~ed~for~self',          'ampgpf' => 'of~having~HEAL~ed~for~self~s',
    'appnsm' => 'HEAL~ed',                          'appgpf' => 'of~HEAL~ed~s',
    'rapnsm' => 'already~having~HEAL~ed',           'rapgpf' => 'of~already~having~HEAL~ed~s',
    'rmpnsm' => 'already~having~HEAL~ed~for~self',  'rmpgpf' => 'of~already~having~HEAL~ed~for~self~s',
    'rppnsm' => 'already~HEAL~ed',                  'rppgpf' => 'of~already~HEAL~ed~s'
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

  ADJECTIVE_EXAMPLES.each do |inflection, form|
    it "inflects the adjective 'BIG'+#{inflection}" do
      Inflector.inflect('BIG', :a, inflection).should == form
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
