## Creating a Corpus

Working with isolated documents gets boring quickly. We typically want to
work with a collection of documents. We represent collections of documents
using the `Corpus` type:
```@docs
Corpus
```

## Standardizing a Corpus

A `Corpus` may contain many different types of documents. It is generally more convenient to standardize all of the documents in a corpus using a single type. This can be done using the `standardize!` function:

```@docs
standardize!
```

## Processing a Corpus

We can apply the same preprocessing steps that are defined for individual documents to an entire corpus at once:

```@repl
using TextAnalysis
crps = Corpus([StringDocument("Document ..!!"),
               StringDocument("Document ..!!")])
prepare!(crps, strip_punctuation)
text(crps[1])
text(crps[2])
```

These operations are run on each document in the corpus individually.

## Corpus Statistics

Often we want to analyze properties of an entire corpus at once. In particular, we work with two key constructs:

* **Lexicon**: The lexicon of a corpus consists of all the terms that occur in any document in the corpus. The lexical frequency of a term tells us how often a term occurs across all documents. Often the most interesting words in a document are those whose frequency within that document is higher than their frequency in the corpus as a whole.
* **Inverse Index**: If we are interested in a specific term, we often want to know which documents in a corpus contain that term. The inverse index provides this information and enables a basic search algorithm.

Because computations involving the lexicon can be time-consuming, a `Corpus` has an empty lexicon by default:

```julia
julia> crps = Corpus([StringDocument("Name Foo"),
                      StringDocument("Name Bar")])
julia> lexicon(crps)
Dict{String,Int64} with 0 entries
```

To work with the lexicon, you must update it first and then access it:

```julia
julia> update_lexicon!(crps)

julia> lexicon(crps)
Dict{String,Int64} with 3 entries:
  "Bar"  => 1
  "Foo"  => 1
  "Name" => 2
```

Once this is done, you can easily address many interesting questions about a corpus:
```julia
julia> lexical_frequency(crps, "Name")
0.5

julia> lexical_frequency(crps, "Foo")
0.25
```

Like the lexicon, the inverse index for a corpus is empty by default:

```julia
julia> inverse_index(crps)
Dict{String,Vector{Int64}} with 0 entries
```

Again, you need to update it before you can work with it:

```julia
julia> update_inverse_index!(crps)

julia> inverse_index(crps)
Dict{String,Vector{Int64}} with 3 entries:
  "Bar"  => [2]
  "Foo"  => [1]
  "Name" => [1, 2]
```

Once you've updated the inverse index, you can easily search the entire corpus:

```julia
julia> crps["Name"]
2-element Vector{Int64}:
 1
 2

julia> crps["Foo"]
1-element Vector{Int64}:
 1

julia> crps["Summer"]
Int64[]
```

## Converting a Corpus to a DataFrame

Sometimes we want to apply non-text-specific data analysis operations to a corpus. The easiest way to do this is to convert a `Corpus` object into a `DataFrame`:

```julia
julia> using DataFrames
julia> crps = Corpus([StringDocument("Name Foo"), StringDocument("Name Bar")])
julia> df = DataFrame(crps)
2×6 DataFrame
 Row │ Language             Title              Author          Timestamp     Length  Text     
     │ String?              String?            String?         String?       Int64?  String?  
─────┼────────────────────────────────────────────────────────────────────────────────────────
   1 │ Languages.English()  Untitled Document  Unknown Author  Unknown Time       8  Name Foo
   2 │ Languages.English()  Untitled Document  Unknown Author  Unknown Time       8  Name Bar
```

This creates a DataFrame with columns for Language, Title, Author, Timestamp, Length, and Text for each document in the corpus.

Alternatively, you can manually construct a DataFrame with custom columns:

```julia
using DataFrames
df = DataFrame(
    text = [text(doc) for doc in crps.documents],
    language = languages(crps),
    title = titles(crps),
    author = authors(crps),
    timestamp = timestamps(crps)
)
```

## Corpus Metadata

You can retrieve the metadata for every document in a `Corpus` at once:

* `languages()`: What language is each document in? Defaults to `Languages.English()`, a Language instance defined by the Languages package.
* `titles()`: What is the title of each document? Defaults to `"Untitled Document"`.
* `authors()`: Who wrote each document? Defaults to `"Unknown Author"`.
* `timestamps()`: When was each document written? Defaults to `"Unknown Time"`.

```julia
julia> crps = Corpus([StringDocument("Name Foo"),
                      StringDocument("Name Bar")])

julia> languages(crps)
2-element Vector{Languages.English}:
 Languages.English()
 Languages.English()

julia> titles(crps)
2-element Vector{String}:
 "Untitled Document"
 "Untitled Document"

julia> authors(crps)
2-element Vector{String}:
 "Unknown Author"
 "Unknown Author"

julia> timestamps(crps)
2-element Vector{String}:
 "Unknown Time"
 "Unknown Time"
```

You can change the metadata fields for each document in a `Corpus`. These functions set the same metadata value for every document:

```julia
julia> languages!(crps, Languages.German())
julia> titles!(crps, "")
julia> authors!(crps, "Me")
julia> timestamps!(crps, "Now")
```
Additionally, you can specify the metadata fields for each document in a `Corpus` individually:

```julia
julia> languages!(crps, [Languages.German(), Languages.English()])
julia> titles!(crps, ["", "Untitled"])
julia> authors!(crps, ["Ich", "You"])
julia> timestamps!(crps, ["Unbekannt", "2018"])
```
