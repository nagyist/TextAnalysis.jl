## Evaluation Metrics

Natural Language Processing tasks require evaluation metrics. TextAnalysis currently provides the following evaluation metrics:

* [ROUGE-N](https://en.wikipedia.org/wiki/ROUGE_(metric))
* [ROUGE-L](https://en.wikipedia.org/wiki/ROUGE_(metric))

* [BLEU (bilingual evaluation understudy)](https://en.wikipedia.org/wiki/BLEU)

## ROUGE-N, ROUGE-L, ROUGE-L-Summary
These metrics evaluate text based on the overlap of N-grams between the system and reference summaries.

```@docs
argmax
average
rouge_n
rouge_l_sentence
rouge_l_summary
```

### ROUGE-N Example

```@example
using TextAnalysis

candidate_summary = "Brazil, Russia, China and India are growing nations. They are all an important part of BRIC as well as regular part of G20 summits."
reference_summaries = ["Brazil, Russia, India and China are the next big political powers in the global economy. Together referred to as BRIC(S) along with South Korea.", "Brazil, Russia, India and China are together known as the BRIC(S) and have been invited to the G20 summit."]

# Calculate ROUGE-N scores for different N values
rouge_2_scores = rouge_n(reference_summaries, candidate_summary, 2)
rouge_1_scores = rouge_n(reference_summaries, candidate_summary, 1)

# Get the best scores using argmax
results = [rouge_2_scores, rouge_1_scores] .|> argmax
```

### ROUGE-L Examples

ROUGE-L measures the longest common subsequence between the candidate and reference summaries:

```@example
using TextAnalysis

candidate = "Brazil, Russia, China and India are growing nations."
references = [
    "Brazil, Russia, India and China are the next big political powers.", 
    "Brazil, Russia, India and China are BRIC nations."
]

# ROUGE-L for sentence-level evaluation
sentence_scores = rouge_l_sentence(references, candidate)

# ROUGE-L for summary-level evaluation (requires β parameter)
summary_scores = rouge_l_summary(references, candidate, 8)
```

## BLEU (bilingual evaluation understudy)

```@docs
bleu_score
```

Example adapted from [NLTK](https://www.nltk.org/api/nltk.translate.bleu_score.html):

```@example
using TextAnalysis

reference1 = [
    "It", "is", "a", "guide", "to", "action", "that",
    "ensures", "that", "the", "military", "will", "forever",
    "heed", "Party", "commands"
]
reference2 = [
    "It", "is", "the", "guiding", "principle", "which",
    "guarantees", "the", "military", "forces", "always",
    "being", "under", "the", "command", "of", "the",
    "Party"
]
reference3 = [
    "It", "is", "the", "practical", "guide", "for", "the",
    "army", "always", "to", "heed", "the", "directions",
    "of", "the", "party"
]

hypothesis1 = [
    "It", "is", "a", "guide", "to", "action", "which",
    "ensures", "that", "the", "military", "always",
    "obeys", "the", "commands", "of", "the", "party"
]

# Calculate BLEU score
score = bleu_score([[reference1, reference2, reference3]], [hypothesis1])
```
