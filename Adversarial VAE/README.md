# Third Graduate Machine Learning Project Highlights

This project was a collaborative effort with Steve Meadows and Brooke Walters, focusing on a complex cross-modal learning challenge.

## Project Overview

We developed a variational autoencoder (VAE) with adversarial training to predict ADT protein expression from RNA in unpaired single-cell sequencing data. The model incorporates multiple discriminators and a gradient reversal layer to enforce a modality-agnostic latent space.

## Key Achievements

Achieved a 0.75 Pearson correlation on Kaggle using multi-objective Bayesian optimization (Meta’s Ax and BoTorch libraries) to balance reconstruction accuracy and latent space integration.

Built the model using PyTorch and PyTorch Lightning, including dynamic training visualizations with TensorBoard, UMAP, PCA, and parallel coordinate plots.

Enhanced training stability through techniques like KL divergence annealing (Annealer), cosine learning rate scheduling, L2 regularization, and the AdamW optimizer.

Experimented with Wasserstein GANs (WGAN-GP) for improved adversarial stability and fine-tuned a multi-discriminator setup to maintain expressiveness and avoid latent space collapse.

## Acknowledgments

Special thanks to Zach DeBruine for guidance and support throughout the project.

## Links

Shiny App: https://ldavis9997.shinyapps.io/Biological_VAE/

## Tags

Machine Learning, Graduate School, VAEs, GANs

