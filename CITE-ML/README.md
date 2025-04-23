# Abstract Neural Evolution  

**Note**: To explore the full analysis, please download and open the HTML report in your browser.

## Project Purpose

Predict Antibody-Derived Tag (ADT) protein expression from single-cell RNA sequencing data using advanced machine learning. By modeling 639 gene-expression features against 25 ADT targets, we investigate how deep networks capture complex, non-linear RNA→protein relationships and compare their performance to classical regression.

## High-Level Workflow

- **Data Preparation & EDA**  
  • 4,000 training cells (639 RNA features + 25 ADT measurements) and 1,000 test cells (RNA only)  
  • PCA and density analyses to characterize feature variance and detect structure  

- **Baseline Modeling**  
  • Multiple linear regression (matrix-based OLS) as a reference—achieved Pearson ≈ 0.802  

- **Custom Neural Network (Base R)**  
  • Four layers with He initialization, ReLU/swish activations, dropout, batch normalization, mini-batch training, ADAM optimizer, and early stopping  
  • Manual hyperparameter sweeps elevated Pearson to > 0.84  

- **`torch` Implementation & Hyperparameter Tuning**  
  • Leverage `torch` for efficient forward/backward passes, built-in optimizers, and normalization layers  
  • Grid and Bayesian optimization (via `ParBayesianOptimization`) over learning rate, architecture depth, dropout, batch size, etc.  
  • Final feed-forward model achieved Pearson ≈ 0.858 and robust generalization  

- **Diagnostics & Explainability**  
  • Monitored training/validation loss, gradient norms, and generalization gap  
  • Explored batch vs. layer normalization, activation choices, and L2 regularization  
  • Investigated ensemble strategies and local optima to strengthen predictive stability  

## Key Outcome

A tuned feed-forward neural network consistently outperforms linear regression on RNA→ADT prediction (Pearson 0.858 vs. 0.802), demonstrating the value of modern deep-learning architectures—even on relatively small, high-dimensional biological datasets.

---

Thank you to collaborators and mentors for their insights and feedback throughout this work.
