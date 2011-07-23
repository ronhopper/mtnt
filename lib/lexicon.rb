class Lexicon

  def self.[](id)
    @cache ||= load
    @cache[id.upcase]
  end

  def self.save
    return unless @cache
    filename = File.join('data', 'lexicon')
    File.open(filename, 'w') do |f|
      @cache.keys.sort_by { |k| k[1..-1].to_i }.each do |id|
        f.write "#{id}|#{@cache[id]}\n"
      end
    end
    true
  end

  def self.parse_gsubs(gsubs)
    gsubs.to_s.split(' ').map do |rule|
      tag, pattern, text, condition = rule.tr('!', '|').split('/')
      tag = nil if tag == ''
      [tag, %r{#{pattern}}, text, condition && %r{^#{condition}$}]
    end
  end

private

  def self.load
    data = {}
    filename = File.join('data', 'lexicon')
    File.open(filename) do |f|
      f.each do |line|
        id, *attrs = line.chomp.split('|')
        data[id] = build_lexeme(attrs)
      end
    end
    data
  end

  def self.build_lexeme(attrs)
    Lexeme.new :lemma => attrs[0],
               :pos => attrs[1].to_sym,
               :tags => parse_tags(attrs[2]),
               :translation => attrs[3],
               :gsubs => parse_gsubs(attrs[4]),
               :etymology => attrs[5],
               :explanation => attrs[6] || '',
               :quality => (attrs[7] || '').split(',').map(&:to_i)
  end

  def self.parse_tags(tags)
    tags.to_s.split(',').map(&:to_sym)
  end

end

