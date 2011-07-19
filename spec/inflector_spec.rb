require './lib/inflector'

describe Inflector do

  NOUN_EXAMPLES = {
    'ns' => 'BOOK',    'np' => 'BOOK~s',
    'gs' => 'of~BOOK', 'gp' => 'of~BOOK~s',
    'ds' => 'to~BOOK', 'dp' => 'to~BOOK~s',
    'as' => '>~BOOK',  'ap' => '>~BOOK~s',
    'vs' => '@~BOOK',  'vp' => '@~BOOK~s'
  }

  NOUN_EXAMPLES.each do |inflection, form|
    it "inflects the noun 'BOOK'+#{inflection}" do
      Inflector.inflect('BOOK', :noun, inflection).should == form
    end
  end

end
