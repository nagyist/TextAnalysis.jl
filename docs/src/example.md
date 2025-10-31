# Extended Usage Example

To show you how text analysis works in practice, we'll work with a text corpus composed of political speeches from American presidents given as part of the State of the Union Address tradition.

```julia
using TextAnalysis

# Load a directory of text files as a corpus
# Note: For testing, use "test/data/sotu" path in the TextAnalysis.jl repository
crps = DirectoryCorpus("sotu")

# Standardize all documents to StringDocument type for consistency
standardize!(crps, StringDocument)

# Work with a subset for faster processing
# Note: Adjust the range based on available documents (e.g., 1:25 if only 29 documents exist)
crps = Corpus(crps[1:min(length(crps), 25)])

# Preprocessing: convert to lowercase and remove punctuation
remove_case!(crps)
prepare!(crps, strip_punctuation)

# Build the lexicon and inverse index for efficient searching
update_lexicon!(crps)
update_inverse_index!(crps)

# Search for documents containing specific terms
freedom_docs = crps["freedom"]
println("Documents mentioning 'freedom': ", length(freedom_docs))

# Create a document-term matrix for numerical analysis
m = DocumentTermMatrix(crps)

# Convert to dense matrix representation
D = dtm(m, :dense)
println("Document-term matrix size: ", size(D))

# Apply TF-IDF (Term Frequency-Inverse Document Frequency) transformation
T = tf_idf(D)
println("TF-IDF matrix size: ", size(T))

# Additional analysis examples
println("\nCorpus Statistics:")
println("  Vocabulary size: ", length(lexicon(crps)))
println("  Matrix density: ", count(x -> x > 0, D) / length(D))

# Find most frequent terms
lex = lexicon(crps)
sorted_words = sort(collect(lex), by=x->x[2], rev=true)
println("  Most frequent terms: ", [word for (word, count) in sorted_words[1:5]])

# Search for documents containing multiple terms
america_docs = crps["america"]
democracy_docs = crps["democracy"]
println("  Documents mentioning 'america': ", length(america_docs))
println("  Documents mentioning 'democracy': ", length(democracy_docs))

# For clustering analysis, you would need additional packages:
# using MultivariateStats, Clustering
# cl = kmeans(T, 5)
```

This example demonstrates the core TextAnalysis workflow:

1. **Data Loading**: Load multiple documents from a directory
2. **Standardization**: Ensure all documents use the same representation
3. **Preprocessing**: Clean the text (case normalization, punctuation removal)
4. **Indexing**: Build lexicon and inverse index for efficient operations
5. **Search**: Find documents containing specific terms
6. **Vectorization**: Convert text to numerical representation (DTM)
7. **Transformation**: Apply TF-IDF weighting for better feature representation
8. **Analysis**: Explore corpus statistics and term frequencies
