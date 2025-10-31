##############################################################################
#
# The hash trick: use a hash function instead of a lexicon to determine the
# columns of a DocumentTermMatrix-like encoding of the data
#
# To produce a DTM for a Corpus for which we do not have an existing lexicon,
# we need someway to map the terms from each document into column indices.
#
# We use the now standard "Hash Trick" (CITATION NEEDED), in which we
# hash strings and then reduce the resulting integers modulo N, which
# defines the numbers of columns we want our DTM to have. This amounts to
# doing a non-linear dimensionality reduction with low probability that similar
# terms hash to the same dimension.
#
# To make things easier, we wrap Julia's hash functions in a new type,
# TextHashFunction, which maintains information about the desired cardinality
# of the hashes.
#
##############################################################################

mutable struct TextHashFunction
    hash_function::Function
    cardinality::Int
end

"""
    TextHashFunction(cardinality)
    TextHashFunction(hash_function, cardinality)

The need to create a lexicon before constructing a document term matrix is often prohibitive.
This implementation employs the "Hash Trick" technique, which replaces terms with their hashed 
values using a hash function that outputs integers from 1 to N.

# Arguments
- `cardinality`: Maximum index used for hashing (default: 100)
- `hash_function`: Function used for hashing process (default: built-in `hash` function)

# Examples
```julia-repl
julia> h = TextHashFunction(10)
TextHashFunction(hash, 10)
```
"""
TextHashFunction(cardinality::Int) = TextHashFunction(hash, cardinality)

TextHashFunction() = TextHashFunction(hash, 100)

cardinality(h::TextHashFunction) = h.cardinality

"""
    index_hash(str, TextHashFunc)

Show mapping of string to integer using the hash trick.

# Arguments
- `str`: String to be hashed
- `TextHashFunc`: TextHashFunction object containing hash configuration

# Examples
```julia-repl
julia> h = TextHashFunction(10)
TextHashFunction(hash, 10)

julia> index_hash("a", h)
8

julia> index_hash("b", h)
7
```
"""
function index_hash(s::AbstractString, h::TextHashFunction)
    return Int(rem(h.hash_function(s), h.cardinality)) + 1
end
