# Warehouse Object Detection: Evaluation and Deployment Design

This technical case study examines the evaluation and deployment of a real-time **YOLOv4-Tiny object detection system** for warehouse and industrial environments. The analysis goes beyond overall model accuracy to explore how class-level performance and dataset representativeness affect evaluation reliability. It also investigates non-maximum suppression (NMS) threshold sensitivity, robustness under image transformations, and loss-based hard-negative mining (HNM) to better understand detection errors and model behavior.

The study connects these evaluation methods to a **Dockerized inference pipeline with UDP video streaming**. It highlights how model selection and post-processing decisions influence the broader system and discusses practical considerations for deployment and monitoring. Together, these analyses demonstrate the importance of evaluating computer vision systems beyond aggregate metrics to support reliable real-world applications.

### Case Study

- **[Read the Technical Case Study (Markdown)](Case_Analysis.md)**
- **[View the Full Paper (PDF)](Case_Analysis.pdf)**