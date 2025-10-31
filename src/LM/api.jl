"""
$(TYPEDSIGNATURES)

Evaluate the score with masked out-of-vocabulary words.

The arguments are the same as for [`score`](@ref).
"""
function maskedscore(m::Langmodel, temp_lm::DefaultDict, word, context)::Float64
    score(m, temp_lm, lookup(m.vocab, [word])[begin], lookup(m.vocab, [context])[begin])
end

"""
$(TYPEDSIGNATURES)

Evaluate the log score of a word in a given context.

The arguments are the same as for [`score`](@ref) and [`maskedscore`](@ref).
"""
function logscore(m::Langmodel, temp_lm::DefaultDict, word, context)::Float64
    log2(maskedscore(m, temp_lm, word, context))
end

"""
$(TYPEDSIGNATURES)

Calculate the cross-entropy of the model for a given evaluation text.

Input text must be a `Vector` of n-grams of the same length.
"""
function entropy(m::Langmodel, lm::DefaultDict, text_ngram::AbstractVector)::Float64
    n_sum = sum(text_ngram) do ngram
        ngram = split(ngram)
        logscore(m, lm, ngram[end], join(ngram[begin:end-1], " "))
    end
    return n_sum / length(text_ngram)
end

"""
$(TYPEDSIGNATURES)

Calculate the perplexity of the given text.

This is simply `2^entropy` for the text, so the arguments are the same as [`entropy`](@ref).
"""
function perplexity(m::Langmodel, lm::DefaultDict, text_ngram::AbstractVector)::Float64
    return 2^(entropy(m, lm, text_ngram))
end
