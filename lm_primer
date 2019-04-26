## A primer to linear models

Let's suppose:
* the expression of a gene is around 4 (whatever units) in a certain population.
* half of this population was treated with a drug that doubles (+100% increase) the expression. Thus, in this subpopulation expression will be around 8.
* we collected samples from the population on Monday (batch 1) and Wednesday (batch 2). Wednesday was warmer, the population had ice cream after lunch, and since our gene is linked with glucose metabolism those samples carried and extra expression of 50%.

```R
set.seed(1)

treat <- factor(rep(c("_no", "_yes"), times=50))
batch <- factor(rep(1:2, each=50))
expression <- 4 + rnorm(100) +            # base expression around 4
              2 * (as.numeric(batch)-1) + # samples in batch 2 have +50%
              4 * (as.numeric(treat)-1)   # treated samples have +100%
```

The `expression` is the observed value that we try to fit the model to. The coefficients for `batch` and `treat` should be around 2 and 4 respectively. 

Let's see what each model tells us:

* `lm(formula = expression ~ treat + batch)` --> `intercept` is the base expression of the population without treatment under Monday conditions (our control group). The coefficient `treat_yes` is the average increase after treatment (regardless of the batch) and `batch_2` is the increase in expression we saw on Wednesday due to icecream consumption:

```R
Call:
lm(formula = expression ~ treat + batch)

Residuals:
     Min       1Q   Median       3Q      Max
-2.22851 -0.62584 -0.01613  0.55216  2.19765

Coefficients:
            Estimate Std. Error t value Pr(>|t|)
(Intercept)   4.1871     0.1564   26.77   <2e-16 ***
treat_yes     3.8267     0.1806   21.19   <2e-16 ***
batch2        2.0169     0.1806   11.17   <2e-16 ***
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 0.9031 on 97 degrees of freedom
Multiple R-squared:  0.8553,    Adjusted R-squared:  0.8524
F-statistic: 286.8 on 2 and 97 DF,  p-value: < 2.2e-16
```

* `lm(formula = expression ~ 0 + treat + batch)` --> there's no intercept here, and the base expression of the population without treatment under Monday conditions (our control group) is the `treat_no` coefficient. The `treat_yes` coefficient is now the base expression of the population *with* treatment under normal conditions, and the actual increase is `treat_yes$Estimate - treat_no$Estimate`. Which is *exactly* the same value we obtained in the `treat_yes` coefficient in the model including the intercept. Thus, this 2 models are **equivalent**, taking especial care of the interpretation of the coefficients. The main difference in **limma** is that here one cannot look at the significance of the coefficient, but explicitly define a `treat_yes - treat_no` contrast.

```R
Call:
lm(formula = expression ~ 0 + treat + batch)

Residuals:
     Min       1Q   Median       3Q      Max
-2.22851 -0.62584 -0.01613  0.55216  2.19765

Coefficients:
          Estimate Std. Error t value Pr(>|t|)
treat_no    4.1871     0.1564   26.77   <2e-16 ***
treat_yes   8.0138     0.1564   51.23   <2e-16 ***
batch2      2.0169     0.1806   11.17   <2e-16 ***
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 0.9031 on 97 degrees of freedom
Multiple R-squared:  0.9859,    Adjusted R-squared:  0.9854
F-statistic:  2257 on 3 and 97 DF,  p-value: < 2.2e-16

R> 8.0138-4.1871
[1] 3.8267
```

* `lm(formula = expression ~ 0 + batch + treat)` --> there's no intercept either, and the `treat_yes` is the average increase after treatment (regardless of the batch) as in the formula including the intercept:

```R
Call:
lm(formula = expression ~ 0 + batch + treat)

Residuals:
     Min       1Q   Median       3Q      Max
-2.22851 -0.62584 -0.01613  0.55216  2.19765

Coefficients:
          Estimate Std. Error t value Pr(>|t|)
batch1      4.1871     0.1564   26.77   <2e-16 ***
batch2      6.2040     0.1564   39.66   <2e-16 ***
treat_yes   3.8267     0.1806   21.19   <2e-16 ***
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 0.9031 on 97 degrees of freedom
Multiple R-squared:  0.9859,    Adjusted R-squared:  0.9854
F-statistic:  2257 on 3 and 97 DF,  p-value: < 2.2e-16
```

**Conclusion**
What is the model that best *fits* our question? The 3 models tell us the same, provided careful interpretation of the coefficients. The difference with estimating the pvalues depends on the degrees of freedom of the models and the standard error associated with the coefficient. But also keep in mind, models with more terms (coefficients) tend to overfit and simpler models are always preferred.

The least convoluted and to me more directly interpretable is including the intercept (`lm(formula = expression ~ batch + treat)`), though `lm(formula = expression ~ 0 + batch + treat)` is semantically equivalent in case we're interested in the differences based on treatment only (there's no coefficient capturing the increase of batch 2, one needs to manually subtract the base batch 1 expression from batch 2).

**Remember:** the significance of a coefficient is tested with a t-test, comparing the predicted expression with and without the coefficient.

**Note:** we should always choose our models based on what better explains our question, not on which is more significant.

**Note:** as a side experiment, try to model *without* the batch term: since (un)treated samples are randomly distributed between the two batches, the differences between the treatments are still well captured and the coefficients significant!

```R
Call:
lm(formula = expression ~ treat)

Residuals:
    Min      1Q  Median      3Q     Max
-3.2369 -1.0172 -0.1183  0.9856  3.2061

Coefficients:
            Estimate Std. Error t value Pr(>|t|)
(Intercept)   5.1955     0.1921   27.05   <2e-16 ***
treat_yes     3.8267     0.2717   14.09   <2e-16 ***
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 1.358 on 98 degrees of freedom
Multiple R-squared:  0.6694,    Adjusted R-squared:  0.666
F-statistic: 198.4 on 1 and 98 DF,  p-value: < 2.2e-16
```

**Note:**  try to model with a single term capturing both the batch and the treatment, as we do very (too) often. The differences are well captured and coefficients significant, **but** a) we're losing power as we have less points per dummy variable (this means we need more samples, which is specially a problem in the current underpowered rna-seq experiments!), and b) if he had more levels in treatment it'd be difficult to deconvolute the batch effect:

```R
Call:
lm(formula = expression ~ paste(treat, batch))

Residuals:
     Min       1Q   Median       3Q      Max
-2.21954 -0.63146 -0.02511  0.56114  2.20663

Coefficients:
                          Estimate Std. Error t value Pr(>|t|)
(Intercept)                 4.1961     0.1815  23.113  < 2e-16 ***
paste(treat, batch)_no 2    1.9989     0.2567   7.786 8.05e-12 ***
paste(treat, batch)_yes 1   3.8088     0.2567  14.835  < 2e-16 ***
paste(treat, batch)_yes 2   5.8436     0.2567  22.760  < 2e-16 ***
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 0.9077 on 96 degrees of freedom
Multiple R-squared:  0.8554,    Adjusted R-squared:  0.8508
F-statistic: 189.2 on 3 and 96 DF,  p-value: < 2.2e-16
```
