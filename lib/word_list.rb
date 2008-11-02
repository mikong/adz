class WordList < Array
  cattr_accessor :delimiter
  self.delimiter = ','
  
  def initialize(*args)
    add(*args)
  end
  
  def add(*words)
    words.flatten!
    concat(words)
    clean!
    self
  end
  
  def remove(*words)
    words.flatten!
    delete_if { |word| words.include?(word) }
    self
  end
  
  def to_s
    clean!
    
    map do |word|
      word.include?(delimiter) ? "\"#{word}\"" : word
    end.join(delimiter.end_with?(" ") ? delimiter : "#{delimiter}")
  end
  
  private
  
    def clean!
      reject!{|t| t.blank?}
      map!{|t| t.strip}
      uniq!
    end
  
    class << self
      
      def from(source)
        word_list = WordList.new
        
        case source
        when Array
          source.each{|w| word_list.add(WordList.from(w))}
        else
          string = source.to_s.dup
          
          string.gsub!(/"(.*?)"\s*#{delimiter}?\s*/) { word_list << $1; "" }
          string.gsub!(/'(.*?)'\s*#{delimiter}?\s*/) { word_list << $1; "" }
          
          word_list.add(string.split(delimiter))
        end
      end
    end
end
