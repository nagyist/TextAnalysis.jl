## Preface

This manual is designed to get you started with text analysis in Julia. It assumes that you are already familiar with the basic methods of text analysis.

TextAnalysis.jl provides a comprehensive suite of tools for analyzing text data, including:

* Document representation and preprocessing
* Corpus creation and management 
* Feature extraction (TF-IDF, n-grams, co-occurrence matrices)
* Text classification (Naive Bayes)
* Evaluation metrics (ROUGE, BLEU)
* Text summarization and language models

## Installation

The TextAnalysis package can be installed using Julia's package manager:

    Pkg.add("TextAnalysis")

## Loading

In all of the examples that follow, we'll assume that you have the TextAnalysis package fully loaded. This means that we assume you've implicitly typed

    using TextAnalysis

before every snippet of code.

## TextModels

The [TextModels](https://github.com/JuliaText/TextModels.jl) package enhances this library with the addition of practical neural network-based models. Some of that code used to live in this package, but was moved to simplify installation and dependencies. 

