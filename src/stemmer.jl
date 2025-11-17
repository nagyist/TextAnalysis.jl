"""
    stemmer_for_document(d)

Return an appropriate stemmer based on the language of the document.

# Arguments
- `d`: Document for which to select stemmer
"""
function stemmer_for_document(d::AbstractDocument)
    Stemmer(lowercase(Languages.english_name(language(d))))
end

"""
    stem!(doc)
    stem!(crps)

Apply stemming to the document or documents in `crps` using an appropriate stemmer.

Does not support `FileDocument` or Corpus containing `FileDocument`.

# Arguments
- `doc`: Document to apply stemming to
- `crps`: Corpus containing documents to apply stemming to
"""
function stem!(d::AbstractDocument)
    stemmer = stemmer_for_document(d)
    stem!(stemmer, d)
    Snowball.release(stemmer)
end

stem!(stemmer::Stemmer, d::FileDocument) = error("FileDocument cannot be modified")

function stem!(stemmer::Stemmer, d::StringDocument)
    d.text = stem_all(stemmer, d.text)
    nothing
end

function stem!(stemmer::Stemmer, d::TokenDocument)
    d.tokens = stem(stemmer, d.tokens)
    nothing
end

function stem!(stemmer::Stemmer, d::NGramDocument)
    for token in keys(d.ngrams)
        new_token = stem(stemmer, token)
        if new_token != token
            count = get(d.ngrams, new_token, 0)
            d.ngrams[new_token] = count + d.ngrams[token]
            delete!(d.ngrams, token)
        end
    end
end

"""
    stem!(crps::Corpus)

Apply stemming to an entire corpus. Assumes all documents in the corpus have the same language (determined from the first document).

# Arguments
- `crps`: Corpus containing documents to apply stemming to
"""
function stem!(crps::Corpus)
    stemmer = stemmer_for_document(crps.documents[1])
    for doc in crps
        stem!(stemmer, doc)
    end
    Snowball.release(stemmer)
end
