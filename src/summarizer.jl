"""
    summarize(doc; ns=5)

Generate a summary of the document and return the top `ns` sentences.

# Arguments
- `doc`: Document of type `StringDocument`, `FileDocument`, or `TokenDocument`
- `ns`: Number of sentences in the summary (default: 5)

# Returns
- `Vector{SubString{String}}`: Array of the most relevant sentences

# Example
```julia-repl
julia> s = StringDocument("Assume this Short Document as an example. Assume this as an example summarizer. This has too foo sentences.")

julia> summarize(s, ns=2)
2-element Vector{SubString{String}}:
 "Assume this Short Document as an example."
 "This has too foo sentences."
```
"""
function summarize(d::AbstractDocument; ns=5)
    sentences = sentence_tokenize(language(d), text(d))
    num_sentences = length(sentences)
    s = StringDocument.(sentences)
    c = Corpus(s)
    prepare!(c, strip_case | strip_stopwords | stem_words)
    update_lexicon!(c)
    t = tf_idf(dtm(c))
    T = t * t'
    p = pagerank(T)
    return sentences[sort(sortperm(vec(p), rev=true)[1:min(ns, num_sentences)])]
end

"""
    pagerank(A; n_iter=20, damping=0.15)

Compute PageRank scores for nodes in a graph using the power iteration method.

# Arguments
- `A`: Adjacency matrix representing the graph
- `n_iter`: Number of iterations for convergence (default: 20)  
- `damping`: Damping factor for PageRank algorithm (default: 0.15)

# Returns
- `Matrix{Float64}`: PageRank scores for each node
"""
function pagerank(A; n_iter=20, damping=0.15)
    nmax = size(A, 1)
    r = rand(1, nmax)              # Generate a random starting rank.
    r = r ./ norm(r, 1)            # Normalize
    a = (1 - damping) ./ nmax      # Create damping vector

    for _ = 1:n_iter
        s = r * A
        rmul!(s, damping)
        r = s .+ (a * sum(r, dims=2))   # Compute PageRank.
    end

    r = r ./ norm(r, 1)

    return r
end
