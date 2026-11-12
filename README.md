Beyond the Shelves

Optimising Retail Inventory for Higher Availability and Lower Holding Costs

Project: Nigeria Insights Series — Case Study
Company: NovaMart Retail Ltd. (Fictional)
Period Covered: January–December 2025
Tools: Microsoft Excel | MySQL | Power BI

---

1. Project Overview

Beyond the Shelves is a retail operations and inventory analytics project developed to investigate how data analytics can support better inventory management, improve product availability and reduce inventory-related costs.

The project uses a simulated dataset representing the operations of NovaMart Retail Ltd., a fictional Nigerian retail business operating across multiple locations.

The analysis examines sales performance, customer demand, inventory levels, stock availability, replenishment activities, purchasing and supplier performance.

Using Excel, MySQL and Power BI, the project transforms structured operational data into business insights and recommendations that can support more informed inventory and purchasing decisions.

2. Business Problem

Retail businesses must maintain sufficient inventory to meet customer demand without accumulating excessive stock.

Insufficient inventory can result in stockouts and unfulfilled demand, while excessive inventory can increase holding costs, tie up working capital and reduce operational efficiency.

The central business question guiding this project is:

How can NovaMart Retail Ltd. improve inventory availability while reducing excess inventory and associated holding costs?

The analysis investigates the operational factors contributing to inventory inefficiencies and identifies opportunities for improvement.

3. Project Objectives

The project aims to:

- Evaluate sales and demand patterns across products, categories and store locations.
- Assess inventory availability and identify stockout patterns.
- Examine inventory levels against established stock policies.
- Evaluate inventory turnover and estimated holding costs.
- Analyse purchasing activities and supplier delivery performance.
- Identify operational inefficiencies and potential areas for improvement.
- Develop data-driven recommendations to support inventory management decisions.

4. Dataset Overview

The project uses a synthetic retail operations dataset covering January to December 2025.

The dataset contains 14 related tables, comprising eight dimension tables and six fact tables, with approximately 757,681 records.

It represents:

- 15 retail stores.
- 3 distribution centres.
- 120 products.
- 25 suppliers.
- Multiple product categories.
- Sales, demand, inventory, purchasing and delivery activities.

The dataset was structured to support relational analysis using MySQL and interactive reporting in Power BI.

Note: All company names, operational records and analytical results are based on simulated data. They do not represent the actual performance of a real retail business.

5. Tools and Technologies

Tool| Application
Microsoft Excel| Data inspection, preparation and preliminary analysis
MySQL| Database creation, data validation and business analysis
Power BI| Data modelling, DAX calculations and interactive dashboards

6. Analytical Approach

The project followed a structured analytical workflow:

1. Data preparation: Inspected and organised the supplied datasets.
2. Database development: Created a relational database in MySQL and imported the dimension and fact tables.
3. Data validation: Examined record counts, data consistency, relationships and inventory reconciliation.
4. Business analysis: Developed SQL queries to investigate 35 business questions across seven analytical areas.
5. Data modelling: Established relationships between tables in Power BI.
6. Dashboard development: Created interactive reports to communicate key performance indicators and operational findings.
7. Business recommendations: Translated analytical findings into practical improvement opportunities.

7. Key Findings

The analysis produced the following findings:

Sales and Profitability

- Total net sales amounted to approximately ₦100.92 million.
- Gross profit was approximately ₦25.35 million.
- Overall gross profit margin was 25.12%.

Demand and Availability

- Demand fulfilment was approximately 99.97%.
- There were 16 unfulfilled demand units.
- The analysis identified 65 stockout observations across demand-observed product-store days.

Inventory Efficiency

- Closing inventory value was approximately ₦31.18 million.
- Average daily inventory value was approximately ₦31.66 million.
- Inventory turnover was approximately 2.39 times.
- Days inventory outstanding was approximately 153 days.
- Estimated annual holding cost was approximately ₦6.33 million.

Supplier Performance

- Delivery fulfilment rate was approximately 98.33%.
- Accepted quantity rate was approximately 98.08%.
- Supplier on-time delivery performance was approximately 77.90% among 2,995 eligible, fully accepted purchase-order lines.

These findings highlight opportunities to strengthen inventory efficiency, supplier reliability and replenishment decisions.

8. Business Recommendations

Based on the analysis, the following actions are recommended:

1. Review replenishment parameters for products and locations with recurring stock availability issues.
2. Investigate excess inventory and adjust stock policies where appropriate.
3. Strengthen supplier performance monitoring, particularly for suppliers with lower on-time delivery rates.
4. Improve purchasing and delivery tracking to reduce outstanding quantities and delivery delays.
5. Establish regular inventory performance reviews using clearly defined KPIs.
6. Review safety stock and reorder point assumptions against observed demand and supplier lead times.

The recommendations are proposed actions based on the simulated analysis, not implemented business outcomes.

9. Limitations

The project has several limitations:

- The dataset is synthetic and does not represent actual business operations.
- The analysis is based on a defined historical dataset rather than a live inventory management environment.
- Some delivery records contain missing delivery dates. These records require further investigation and are not treated as fully observed delivery outcomes.
- The estimated holding cost depends on the assumed annual holding-cost rate.
- Inventory turnover and days inventory outstanding are aggregate analytical estimates and should be interpreted in the context of the available dataset.
- The analysis identifies patterns and potential operational issues but does not establish causation.

10. Future Opportunities

The current project establishes a foundation for further analytical development.

Potential extensions include:

- Demand forecasting using statistical and machine learning methods.
- Inventory optimisation and safety stock modelling.
- Automated replenishment recommendations.
- Warehouse and distribution network optimisation.
- ERP integration concepts.
- Broader financial and operational performance analysis.

These are proposed future extensions and are not part of the current implementation.

11. Repository Structure

The repository is organised into the following sections:

Beyond-the-Shelves/
│
├── README.md
│
├── Documentation/
│   ├── Business_Analysis_Report.docx
│   ├── Data_Dictionary.docx
│   └── Project_Methodology.md
│
├── Dataset/
│   ├── Dimensions/
│   └── Facts/
│
├── SQL/
│   ├── 01_Database_Setup/Data_Import/Data_Validation/
│ 
│   └── 03_Business_Analysis/
│
├── Power_BI/
│   └── Beyond_the_Shelves_Dashboard.pbix
│
└── Images/
    └── Dashboard_Screenshots/

12. Conclusion

Beyond the Shelves demonstrates how relational database analysis and business intelligence tools can be applied to investigate retail inventory and operational performance.

By integrating data preparation, SQL analysis and Power BI reporting, the project provides a structured approach to identifying inventory inefficiencies and developing evidence-based recommendations.

It also demonstrates the application of data analytics to practical business problems through a complete, simulated retail case study.

---

Project Series: Nigeria Insights Series
Case Study: Beyond the Shelves
Tools: Excel | MySQL | Power BI# Beyond-the-Shelves-
A retail inventory and business performance analysis project using MySQL, Excel and Power BI.
