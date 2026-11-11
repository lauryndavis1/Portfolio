
# Embedding-Based Facial Identification

**Computer Vision | Representation Learning | Vector Retrieval**

## Overview

This project evaluates an embedding-based facial identification system using pretrained Inception-ResNet-v1 models and FAISS vector search. The study examines five technical areas:

- **Facial Representation:** Comparing CASIA-WebFace and VGGFace2 pretrained models for 512-dimensional embedding extraction.
- **Face Detection & Alignment:** Evaluating MTCNN preprocessing and robustness to image degradation.
- **Vector Indexing:** Comparing Brute Force, HNSW, and LSH retrieval strategies across accuracy, latency, and scalability.
- **Candidate Ranking:** Evaluating Recall@K to determine the number of identity matches returned.
- **Enrollment Optimization:** Measuring how multiple reference photographs affect identification accuracy.

## Technical Case Study

- [**Markdown Version**](Case_Analysis.md)
- [**PDF Version**](Case_Analysis.pdf)
