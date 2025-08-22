# SQL_Project
## Projects Summary
  I-Work Layoff Project 
  
  II- Restaurant Order Analysis Project 

## Work Layoff Project 
### Project Overview 

This project focuses on cleaning and preparing a real-world dataset of global tech layoffs using SQL.
The raw dataset contained issues such as duplicates, inconsistent formatting, missing values, and incorrect data types.

The goal was to transform messy raw data into a clean, reliable, and analysis-ready dataset to then explore trends that provide business insights.

### Data Sources
Dataset Used "layoffs.csv" from Github it was public and used for the sake of practice  

### Tools 
-MySQL 

-MySQL Workbench 

### Data Cleaning /Preparation 
Steps taken :
1. Backup & Preparation
   -Created a backup copy of the raw layoffs table (copy_layoffs) to preserve original data.
   -Used a working table (copy_layoffs2) for transformations.
2. Duplicate Removal
  - Applied a window function (ROW_NUMBER) to detect duplicates across multiple columns.
  - Deleted duplicate rows while keeping the first valid entry.
3. Standardization
  - Trimmed whitespace from company names.
  - Fixed inconsistent country formatting (e.g., "United States." → "United States").
   Standardized date column: converted from text (MM/DD/YYYY) to proper SQL DATE type.
4. Handling Missing Values
  - Replaced empty strings in the industry column with NULL.
  - Imputed missing industry values by matching rows with the same company and country.
  - Removed rows with no valid layoff data (total_laid_off and percentage_laid_off both NULL).
5. Final Cleanup
  - Dropped helper columns (like row_num used for deduplication).
  - Produced a final clean dataset ready for analysis and visualization.

## Restaurant Order Analysis Project
### Project Overview 

This project focuses on cleaning, preparing, and analyzing a real-world restaurant order dataset using SQL.
The raw dataset included tables for menu items and customer orders, which contained issues such as missing dates, incorrectly formatted data, and inconsistencies in column names.
The goal was to transform this raw data into a clean, reliable, and analysis-ready dataset in order to explore customer behavior, menu trends, and the most profitable orders.

### Data Sources
Dataset:
-menu_items.csv — contains details of restaurant menu items (item names, categories, prices).
-order_details.csv — contains customer order data (order IDs, item IDs, order dates/times).
!-The datasets were used for practice and realistic scenario analysis.(Public dataset)

### Tools 
-MySQL

-MySQL Workbench

### Data Cleaning /Preparation 

#### Steps taken:
#### Database Setup & Table Creation
-Created a dedicated database Restaurant_Order_Analysis.
-Created menu_items and order_details tables to hold raw CSV data.
-Enabled local_infile and imported CSV files using LOAD DATA for faster loading.

#### Handling Invalid & Missing Data
-Detected invalid dates (0000-00-00) in order_date and replaced them with NULL.
-Temporarily adjusted SQL modes (STRICT_TRANS_TABLES, NO_ZERO_DATE) to allow cleaning.

#### Column & Table Standardization
-Corrected incorrectly imported column names (e.g., ï»¿menu_item_id → menu_item_id).
-Ensured consistent data types for dates, times, and numeric columns.

#### Data Integration
-Created a join_table by combining menu_items and order_details to facilitate analysis.

#### Exploratory Analysis / Aggregations
-Counted orders per item and category to find popular menu items.
-Calculated total spending per order and identified the top 5 highest spending orders.
-Analyzed item distribution per category within individual orders.
-Generated summary statistics for menu items (total items, average price, most/least expensive).

#### Final Dataset for Analysis
-The resulting join_table is clean, standardized, and ready for advanced queries, trend analysis, and business insights.

#### Key Insights
-Top-Selling Items: Certain dishes were ordered far more frequently, revealing customer favorites.
-Popular Categories: Categories like Italian and Desserts had the highest order counts.
-High-Value Orders: Top 5 orders generated the most revenue, highlighting profitable item combinations.
-Price Insights: Average and range of menu prices per category help guide pricing strategies.
-Order Patterns: Frequently ordered items together can inform combos or promotions.

