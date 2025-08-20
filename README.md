# SQL_Project
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
