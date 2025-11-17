#  Statistical Language Models

**TextAnalysis** provides the following different language models: 

- **MLE** - Base n-gram model using Maximum Likelihood Estimation.
- **Lidstone** - Base n-gram model with Lidstone smoothing.
- **Laplace** - Base n-gram language model with Laplace smoothing.
- **WittenBellInterpolated** - Interpolated version of the Witten-Bell algorithm.
- **KneserNeyInterpolated** - Interpolated version of Kneser-Ney smoothing.

## APIs

To use the API, first instantiate the desired model and then train it with a training set:

```julia
MLE(word::Vector{T}, unk_cutoff=1, unk_label="<unk>") where { T <: AbstractString}
        
Lidstone(word::Vector{T}, gamma:: Float64, unk_cutoff=1, unk_label="<unk>") where { T <: AbstractString}
        
Laplace(word::Vector{T}, unk_cutoff=1, unk_label="<unk>") where { T <: AbstractString}
        
WittenBellInterpolated(word::Vector{T}, unk_cutoff=1, unk_label="<unk>") where { T <: AbstractString}
        
KneserNeyInterpolated(word::Vector{T}, discount:: Float64=0.1, unk_cutoff=1, unk_label="<unk>") where { T <: AbstractString}
        
(lm::<Languagemodel>)(text, min::Integer, max::Integer)
```
**Arguments:**

 * `word`: Array of strings to store the vocabulary.

 * `unk_cutoff`: Tokens with counts greater than or equal to the cutoff value will be considered part of the vocabulary.

 * `unk_label`: Token for unknown labels.

 * `gamma`: Smoothing parameter gamma.

 * `discount`: Discounting factor for `KneserNeyInterpolated`.

For more information, see the docstrings of the vocabulary functions.

```julia
julia> voc = ["my","name","is","salman","khan","and","he","is","shahrukh","Khan"]

julia> train = ["khan","is","my","good", "friend","and","He","is","my","brother"]
# voc and train are used to train the vocabulary and model respectively

julia> model = MLE(voc)
MLE(Vocabulary(Dict("khan"=>1,"name"=>1,"<unk>"=>1,"salman"=>1,"is"=>2,"Khan"=>1,"my"=>1,"he"=>1,"shahrukh"=>1,"and"=>1…), 1, "<unk>", ["my", "name", "is", "salman", "khan", "and", "he", "is", "shahrukh", "Khan", "<unk>"]))

julia> print(voc)
11-element Vector{String}:
 "my"
 "name"
 "is"
 "salman"
 "khan" 
 "and" 
 "he" 
 "is"
 "shahrukh"
 "Khan"
 "<unk>"

# You can see the "<unk>" token is added to voc 
julia> fit = model(train,2,2) # considering only bigrams

julia> unmaskedscore = score(model, fit, "is" ,"<unk>") # score output P(word | context) without replacing context word with "<unk>"
0.3333333333333333

julia> masked_score = maskedscore(model,fit,"is","alien")
0.3333333333333333
# As expected, maskedscore is equivalent to unmaskedscore with context replaced with "<unk>"

```

!!! note

    When you call `MLE(voc)` for the first time, it will update your vocabulary set as well. 

## Evaluation Methods

### `score` 

Used to evaluate the probability of a word given its context (*P(word | context)*):

```@docs
score
```

**Arguments:**

1. `m`: Instance of `Langmodel` struct.
2. `temp_lm`: Output of function call of instance of `Langmodel`.
3. `word`: String of the word.
4. `context`: Context of the given word.

- For `Lidstone` and `Laplace` models, smoothing is applied.
- For interpolated language models, `KneserNey` and `WittenBell` smoothing are provided. 

### `maskedscore` 
```@docs
maskedscore
```

### `logscore`
```@docs
logscore
```


### `entropy`

```@docs
entropy
```

### `perplexity`
```@docs
perplexity
```

## Preprocessing

The following functions are available for preprocessing:
```@docs
everygram
padding_ngram
```

## Vocabulary 

A struct to store language model vocabulary.

It checks membership and filters items by comparing their counts to a cutoff value.

It also adds a special "unknown" token which unseen words are mapped to:

```@repl
using TextAnalysis
words = ["a", "c", "-", "d", "c", "a", "b", "r", "a", "c", "d"]
vocabulary = Vocabulary(words, 2) 

# Look up a sequence of words in the vocabulary

word = ["a", "-", "d", "c", "a"]

lookup(vocabulary ,word)
```
