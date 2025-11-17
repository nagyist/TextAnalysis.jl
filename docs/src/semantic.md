## LSA: Latent Semantic Analysis

Often we want to analyze documents from the perspective of their semantic content. One standard approach to doing this is to perform Latent Semantic Analysis (LSA) on the corpus.
```@docs
lsa
```

LSA uses `tf_idf` for computing term statistics.


```@repl
using TextAnalysis
crps = Corpus([
  StringDocument("this is a string document"),
  TokenDocument("this is a token document")
])
lsa(crps)
```

LSA can also be performed directly on a `DocumentTermMatrix`:
```@repl
using TextAnalysis
crps = Corpus([
  StringDocument("this is a string document"),
  TokenDocument("this is a token document")
]);
update_lexicon!(crps)

m = DocumentTermMatrix(crps)

lsa(m)
```


## LDA: Latent Dirichlet Allocation

Another way to analyze the semantic content of a corpus is to use [Latent Dirichlet Allocation](https://en.wikipedia.org/wiki/Latent_Dirichlet_allocation).

First, we need to create a DocumentTermMatrix:
```@docs
lda
```
```@repl
using TextAnalysis
crps = Corpus([
  StringDocument("This is the Foo Bar Document"),
  StringDocument("This document has too Foo words")
]);
update_lexicon!(crps)
m = DocumentTermMatrix(crps)

k = 2             # Number of topics
iterations = 1000 # Number of Gibbs sampling iterations
α = 0.1           # Hyperparameter for document-topic distribution
β = 0.1           # Hyperparameter for topic-word distribution

ϕ, θ = lda(m, k, iterations, α, β);
ϕ  # Topic-word distribution matrix
θ  # Document-topic distribution matrix
```

The `lda` function returns two matrices:
- `ϕ` (phi): The topic-word distribution matrix showing the probability of each word in each topic
- `θ` (theta): The document-topic distribution matrix showing the probability of each topic in each document

See `?lda` for more help.
