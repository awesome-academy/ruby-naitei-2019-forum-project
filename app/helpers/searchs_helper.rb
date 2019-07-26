module SearchsHelper
  #####
  # search method
  # input:
  # pat: pattern to search
  # ngram: ngram value (approximately search n-gram algorithm)
  # resources: ActiveRecord name
  # *search_field list of attributes with weighted value
  # output:
  # array of active record
  # #####

  def search pat, ngram, resources, n_output, *search_field
    attrs, w = search_field.transpose

    ret = resources.select(*attrs).map do |res|
      attrs.map{|e| res.send(e)}.zip(w)
    end

    ret = ret.sort_by{|e| n_gram_val pat, ngram, e}.reverse![0..n_output]
    
    ret = ret.map &->(res){resources.find_by id: res[0]}
  end

  private
  
  def n_gram_val pat, n, attributes
    # first item is id
    attributes[1..].map{|(content, weight)| cos_dist(pat, content, n) * weight}.sum.round(3)
  end

  def ngram text, n = 3
    text.strip!
    text.scan(/#{"." * n}/).to_set
  end

  def create_ngram text1, text2, n = 3
    text1.length > n ? [ngram(text1, n), ngram(text2, n)] : [Set.new([text1]), ngram(text2, text1.length)]
  end

  def cos_dist text1, text2, n = 3
    text1, text2 = create_ngram text1, text2, n
    full_text = text1 | text2

    v1 = full_text.map &->(x){text1.include?(x) ? 1 : 0}
    v2 = full_text.map &->(x){text2.include?(x) ? 1 : 0}

    dot_product = v1.zip(v2).map{|(a, b)| a * b}.sum
    magnitude1 = v1.reduce{|a, e| a + e * e}
    magnitude2 = v2.reduce{|a, e| a + e * e}

    (dot_product / Math.sqrt(magnitude1 * magnitude2))
  end
end
