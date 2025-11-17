"""
    tokenize(lang, s)

Split string into words and other tokens such as punctuation.

# Arguments
- `lang`: Language for tokenization rules
- `s`: String to tokenize

# Returns
- `Vector{String}`: Array of tokens extracted from the string

# Example

```julia-repl
julia> tokenize(Languages.English(), "Too foo words!")
4-element Vector{String}:
 "Too"
 "foo"
 "words"
 "!"
```

See also: [`sentence_tokenize`](@ref)
"""
tokenize(lang::S, s::T) where {S<:Language,T<:AbstractString} = WordTokenizers.tokenize(s)


"""
    sentence_tokenize(lang, s)

Split string into individual sentences.

# Arguments
- `lang`: Language for sentence boundary detection rules
- `s`: String to split into sentences

# Returns
- `Vector{SubString{String}}`: Array of sentences extracted from the string

# Example
```julia-repl
julia> sentence_tokenize(Languages.English(), "Here are few words! I am Foo Bar.")
2-element Vector{SubString{String}}:
 "Here are few words!"
 "I am Foo Bar."
```

See also: [`tokenize`](@ref)
"""
sentence_tokenize(lang::S, s::T) where {S<:Language,T<:AbstractString} = WordTokenizers.split_sentences(s)
