# Redlining and Its Impact: A Digital Tool for Social Studies Education

## Project Overview
This project explores the socioeconomic impacts of historical redlining practices in the United States, focusing on how these discriminatory policies have shaped current economic and demographic patterns. The goal is to develop an interactive Shiny web application that integrates historical redlining maps from the **Mapping Inequality** project with current data from the U.S. Census Bureau (USCB). The target audience is middle and high school social studies teachers, providing them with tools and resources to incorporate data literacy into their lessons.

### Key Features:
1. **Interactive Mapping Tool**: Visualize historical HOLC redlining grades alongside recent demographic and economic data.
2. **Predictive Modeling**: Developed a multiple linear regression model to predict current median household income based on economic indicators and historical HOLC grades.

## Background
During the 1930s, the Home Owners’ Loan Corporation (HOLC) assigned mortgage security "grades" to neighborhoods, from "A" (low risk) to "D" (hazardous). These grades influenced discriminatory lending practices, limiting minorities’ access to mortgages and economic opportunities. The **Mapping Inequality** project digitized these historical maps, making them accessible for modern analysis.

### Significance:
This project aims to address the gap in data literacy among educators by offering a practical, interactive tool for classroom use. By visualizing historical and contemporary data, students can better understand the lasting impacts of redlining on socioeconomic mobility.

## Methodology
The project involves several stages of development:
1. **Data Integration**:  
   - Combine HOLC redlining shape files from the Mapping Inequality project with USCB economic and demographic data.  
   - Use R for data cleaning, transformation, and preparation.  
2. **Interactive Web Application**:  
   - Develop the tool using the Shiny package in R for accessibility and interactivity.  
   - Ensure usability for middle and high school teachers and students.  
3. **Exemplar Analysis**:  
   - Explore multiple U.S. cities to investigate correlations between HOLC grades and current data patterns.  
   - Research historical policies and events that influenced these trends.  
4. **Data Visualization**:  
   - Leverage R libraries like `ggplot2` and `leaflet` for clear and engaging visual representations.  
   - Use animations and interactivity to enhance user experience.  
5. **Testing and Refinement**:  
   - Conduct user testing to ensure usability and effectiveness.

## Project Goals
1. Create a Shiny-based web application that combines historical redlining maps with current data.
2. Develop a website hosting the tool along with resources for educators.

## Tools and Technologies
- **Programming Language**: R  
- **Libraries**: `shiny`, `sf`, `leaflet`, `ggplot2`, `tidyverse`, `shinythemes`  
- **Data Sources**: Mapping Inequality, U.S. Census Bureau  
- **Development Tools**: RStudio, GitHub

## Challenges and Considerations
- Ensuring accessibility for users of different technical backgrounds.  
- Addressing the emotional toll of reviewing historical discriminatory practices.  
- Iteratively improving the tool based on feedback from teachers and students.

## Contact
For questions, collaboration, or feedback, please contact:  
**Lauryn Davis**  
Ldavis9997@yahoo.com

## Acknowledgments
- **Mapping Inequality Research Team** for providing open-source historical data.  
- **GVSU Faculty Mentors** for their guidance and support.  
- **U.S. Census Bureau** for providing economic and demographic datasets.
