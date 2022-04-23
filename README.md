# FeatureSelectionBoruta
Feature selection with Boruta

**Language: R**

**Start: 2021**

## Why
I wanted to try the [Boruta algorithm](https://doi.org/10.18637/jss.v036.i11) for feature selection. I tested it with a linear regression model to see if the best three features, according to Boruta, yield a model comparable to a model using all the available features.

- Q2 of the model using the worst 3 features: 0.08
- Q2 of the model using all the features: 0.94
- Q2 of the model using the best 3 features (V5, V8, X12): 0.93

Importance of the features according to Boruta:

![plot of the Boruta importance](/images/plot1.jpg)



