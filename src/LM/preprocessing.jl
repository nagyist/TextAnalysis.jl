"""
    everygram(seq::Vector{T}; min_len::Int=1, max_len::Int=-1) where {T <: AbstractString}

Return all possible n-grams generated from a sequence of items, as a `Vector{String}`.

# Example

```julia-repl
julia> seq = ["To","be","or","not"]
julia> a = everygram(seq, min_len=1, max_len=-1)
 10-element Vector{Any}:
  "or"          
  "not"         
  "To"          
  "be"                  
  "or not" 
  "be or"       
  "be or not"   
  "To be or"    
  "To be or not"
```
   
"""
function everygram(seq::Vector{T}; min_len::Int=1, max_len::Int=-1)::Vector{String} where {T<:AbstractString}
    ngram = String[]
    if max_len == -1
        max_len = length(seq)
    end
    for n in range(min_len, stop=max_len)
        temp = ngramizenew(seq, n)
        ngram = append!(ngram, temp)
    end
    return ngram
end

"""
    padding_ngram(word::Vector{T}, n=1; pad_left=false, pad_right=false, left_pad_symbol="<s>", right_pad_symbol="</s>") where {T <: AbstractString}
   
Pad both left and right sides of a sentence and output n-grams of order n.

This function also pads the original input vector of strings. 

# Example 
```julia-repl
julia> example = ["1","2","3","4","5"]

julia> padding_ngram(example,2,pad_left=true,pad_right=true)
 6-element Vector{Any}:
  "<s> 1" 
  "1 2"   
  "2 3"   
  "3 4"   
  "4 5"   
  "5 </s>"
```
"""
function padding_ngram(
    word::Vector{T}, n=1;
    pad_left=false, pad_right=false,
    left_pad_symbol="<s>", right_pad_symbol="</s>"
) where {T<:AbstractString}
    local seq
    seq = word

    pad_left == true && prepend!(seq, [left_pad_symbol])
    pad_right == true && push!(seq, right_pad_symbol)

    return ngramizenew(seq, n)
end

"""
    ngramizenew(words::Vector{T}, nlist::Integer...) where {T <: AbstractString}   

Generate n-grams from a sequence of words.
   
# Example
```julia-repl
julia> seq=["To","be","or","not","To","not","To","not"]
julia> ngramizenew(seq, 2)
 7-element Vector{Any}:
  "To be" 
  "be or" 
  "or not"
  "not To"
  "To not"
  "not To"
  "To not"
```
"""
function ngramizenew(words::Vector{T}, nlist::Integer...)::Vector{String} where {T<:AbstractString}
    n_words = length(words)

    tokens = String[]

    for n in nlist,
        index in 1:(n_words-n+1)

        token = join(words[index:(index+n-1)], " ")
        push!(tokens, token)
    end
    return tokens
end

