class WordSense
  include DataMapper::Resource
  
  property :id,         Serial
  property :word,       String, :length => 30
  property :synonym_id, Integer
  
  def self.synonyms_of(word)
    find_by_sql(["SELECT * FROM word_senses WHERE word != ?" +
                 "AND synonym_id IN (SELECT synonym_id FROM word_senses WHERE word = ?)", word, word])
  end
end
