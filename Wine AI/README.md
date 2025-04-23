# Wine AI  
Predicting Tasting Note Probabilities from Climate Time Series and Varietal Data

This project explores how environmental factors influence the descriptive language used in wine reviews. Specifically, we modeled the probability of 1,416 tasting note keywords appearing in a wine's review using only climate time series data (from March 1 to November 1, 2022) and grape varietal identifiers. No text-based features from the reviews themselves were used in training, making the project an investigation into how climate conditions and grape genetics contribute to sensory language in wine.

## Project Overview

- **Dataset**: 10,803 wines across 64 varietals. Each wine is associated with 246 days of climate data (min/max temperatures, rainfall, sunshine) and a probabilistic multi-label target derived from wine review word frequencies.
- **Task**: Multi-label regression predicting keyword probabilities using numeric and categorical features only.
- **Evaluation**: Mean Absolute Error (MAE) between predicted and smoothed true keyword probabilities.

## Technical Contributions

- **Feature Engineering**:
  - Created over 30 climate-based features, including rolling means (7/14/30-day), seasonal rainfall averages, temperature drops, and interaction terms (e.g., rain × spring).
  - Generated varietal-level pseudo-reviews by selecting the top-N most probable tasting words. These pseudo-texts were embedded with DistilBERT and reduced using PCA to capture semantic profiles.
  - Clustered review word probabilities using KMeans to derive `n_word_cluster_probabilities`, capturing latent descriptor groupings like citrus/mineral or dark/spicy notes.
  - Included word-level entropy and top-word ratio features to capture diversity and concentration in review vocabulary.

- **Modeling Approaches**:
  - **LightGBM**:
    - Used Tweedie loss and trained separate models across multiple word-cluster resolutions (For example: 30, 60, 90).
    - Feature importance analyses (gain and split count) showed rainfall frequency, seasonal temperature patterns, and varietal entropy as key drivers of prediction.
  - **Feedforward Neural Network**:
    - Two hidden layers with LayerNorm, ReLU, and dropout. Used focal loss and L1 regularization to address label sparsity (~80% zero labels).
    - SHAP explainability revealed the importance of aggregated climate trends and varietal embeddings over granular time series inputs.
  - **Transformer Encoder** (PyTorch):
    - Custom transformer trained on a sequence of just two tokens: varietal embedding and climate feature embedding.
    - Used 512-dim embeddings, 2–3 encoder layers, 4–8 attention heads, GELU activation, and AdamW optimization.
    - Bayesian optimization via Ax/BoTorch used to tune learning rate, dropout, embedding dim, and regularization parameters.
    - Final ensemble model (2 configurations) achieved a competitive **MAE of 0.01873**.

## Explainability & SHAP

To interpret our model predictions, we used SHAP (SHapley Additive exPlanations) on the FNN model. This allowed us to quantify the contribution of each input feature to individual tasting note predictions. Results confirmed that engineered features such as rainfall frequency, varietal identity, and temperature volatility were consistent drivers of both high-confidence and uncertain predictions—reinforcing the impact of careful preprocessing.


## Acknowledgments

Grateful to my project partners **Steve Meadows** and **Brooke Walters** for an outstanding collaboration this semester. Huge thanks to **Zach DeBruine** for your consistent guidance, feedback, and support throughout the course.
