"""
	lsa(dtm::DocumentTermMatrix)
	lsa(crps::Corpus)

Perform Latent Semantic Analysis (LSA) on a corpus or document-term matrix.

"""
lsa(dtm::DocumentTermMatrix) = svd(Matrix(tf_idf(dtm)))
function lsa(crps::Corpus)
    update_lexicon!(crps)
    svd(Matrix(tf_idf(DocumentTermMatrix(crps))))
end
