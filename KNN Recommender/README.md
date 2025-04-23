# Kaggle Challenge One  

**Note**: To explore the full analysis, please download and open the HTML report in your browser.

## Project Purpose

Identify underrepresented bird species from eBird checklists using K-Nearest Neighbors (KNN). Training data spans 85 species, and the goal is to predict the five most likely missing species for each test checklist.

## High-Level Workflow

- **Data Preparation & EDA**  
  • Loaded training (species × checklist counts) and test sets; examined sparsity, skew, and feature distributions  
  • Log-transformed counts to reduce scale disparities; analyzed Manhattan distance distributions for decay parameter tuning  

- **Baseline KNN & Hyperparameter Tuning**  
  • Implemented KNN with Manhattan distance, optimized K via MAE on an 80/20 internal split  
  • Introduced exponential decay and “soft-zero” weighting to down-weigh zeros in test vectors  
  • Parallelized distance computations with `doParallel` for scalable scoring  

- **Grid & Bayesian-Style Search**  
  • Explored σ (decay rate), zero-weight scalar, and K in nested loops; refined ranges in successive passes  
  • Visualized MAE surfaces in 3D to pinpoint global minima  

- **Final Model & Submission**  
  • Best hyperparameters: K = 17, σ = 1.5, soft-zero scalar = 0.25  
  • Achieved MAE = 0.0357 on the official test set  

## Key Outcome

Our tuned KNN pipeline placed **best among all CIS 678 class submissions at GVSU**, achieving an MAE 25% below the recommended threshold.

