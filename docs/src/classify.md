# Classifier

TextAnalysis currently offers a Naive Bayes Classifier for text classification.

To load the Naive Bayes Classifier, use the following command:

    using TextAnalysis: NaiveBayesClassifier, fit!, predict

## Basic Usage

It can be used in the following 3 steps:

1. Create an instance of the Naive Bayes Classifier model:
```@docs
NaiveBayesClassifier
```

2. Fit the model weights on training data:
```@docs
fit!
```
3. Make predictions on new data:
```@docs
predict
```

## Example

```@repl
using TextAnalysis
m = NaiveBayesClassifier([:legal, :financial])
fit!(m, "this is financial doc", :financial)
fit!(m, "this is legal doc", :legal)
predict(m, "this should be predicted as a legal document")
```
