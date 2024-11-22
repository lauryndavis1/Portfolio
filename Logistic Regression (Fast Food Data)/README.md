# README: Analysis of Nutritional Indicators in the Fast Food Industry

## Project Overview
This project analyzes nutritional indicators in fast food items across eight major chains using the "Fastfood" dataset from OpenIntro. The primary focus is to understand caloric content and its relationship with other nutritional indicators, as well as identify predictors of "unhealthy" fast food items.

## Language and Libraries
- **Language**: R  
- **Libraries**:  
  - `tidyverse` for data manipulation and visualization  
  - `caret` for model training and evaluation  
  - `car` for regression diagnostics  

## Dataset
- **Source**: OpenIntro  
- **Observations**: 515  
- **Variables**: 17 (e.g., calories, fat, sugar, protein, restaurant)  
- Includes fast food chains like McDonald’s, Taco Bell, and Chick-fil-A.  

## Research Questions
1. Can calories be predicted using other nutritional indicators (e.g., fat, protein)?  
2. Which fast food chains contribute most to unhealthy items (defined as >750 calories)?

## Methodology
- **Software**: R and RStudio  
- **Techniques**:
  - **Multiple Linear Regression**: To predict caloric content.  
  - **Binary Logistic Regression**: To classify items as "unhealthy" or not, based on a calorie threshold of 750.  
- **Assumptions**:
  - Linearity, normality, independence, and absence of multicollinearity for regression models.

## Key Features
- Statistical modeling with regression.
- Threshold-based classification of unhealthy food items.
- Assumption checks and validation.

## Files
- `data/`: Contains the "Fastfood" dataset.  
- `code/`: R scripts for data processing and modeling.  
- `results/`: Outputs and visualizations.

## Contact
For inquiries, contact Lauryn Davis at Ldavis9997@yahoo.com.  
