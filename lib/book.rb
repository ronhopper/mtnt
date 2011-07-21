class Book

  def self.[](name)
    @books ||= {}
    @books[name] ||= new(name)
  end

  def self.clear_cache!
    @books = {}
  end

  def initialize(name)
    @data = []
    filename = File.join('data', 'books', name)
    File.open(filename) do |f|
      words = i = j = k = nil
      f.each do |line|
        if line[0] != ' '
          i, j = parse_chapter_verse(line)
          @data[i] ||= []
          @data[i][j] = words = []
          k = 0
        else
          words << parse_word("#{name}-#{i + 1}-#{j + 1}-#{k += 1}", line.chomp.strip)
        end
      end
    end
  end

  def [](i)
    @data[i - 1]
  end

private

  def parse_chapter_verse(line)
    i, j = line.split(':').map(&:to_i)
    [i - 1, j - 1]
  end

  def parse_word(id, word)
    parts = word.split(' ')
    position = parts.shift.to_i
    form = parts.shift
    lemma, inflection = if parts.empty? then [] else parts.shift.split('+') end
    Word.new id, position, form, lemma, inflection, parts
  end

end
