-- ================================================================
--  DATA CLEANING WORKFLOW: LAYOFFS DATASET
--  Steps:
--   1. Create a backup copy of the original data
--   2. Remove duplicates
--   3. Standardize text formatting (company, country, etc.)
--   4. Fix date formatting
--   5. Handle missing values (industry, layoffs)
--   6. Final cleanup
-- ================================================================

-- Disable SQL safe updates (allows deletes/updates without keys)
SET SQL_SAFE_UPDATES = 0;

-- =============================
-- STEP 1: CREATE BACKUP TABLE
-- =============================

-- View original dataset
SELECT *
FROM layoffs;

-- Create a new table with the same structure as layoffs
CREATE TABLE copy_layoffs LIKE layoffs;

-- Insert all rows (full backup of layoffs)
INSERT INTO copy_layoffs
SELECT *
FROM layoffs;

-- Verify the copied data
SELECT *
FROM copy_layoffs;


-- =============================
-- STEP 2: IDENTIFY & REMOVE DUPLICATES
-- =============================

-- Use a CTE with ROW_NUMBER to flag duplicate rows
WITH duplicate_cte AS (
    SELECT 
        *,
        ROW_NUMBER() OVER (
            PARTITION BY company, location, industry, total_laid_off, 
                         percentage_laid_off, `date`, stage, country, funds_raised_millions
        ) AS row_num
    FROM copy_layoffs
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1;   -- rows > 1 are duplicates


-- Create a new table to store rows with row numbers
CREATE TABLE copy_layoffs2 (
  company TEXT,
  location TEXT,
  industry TEXT,
  total_laid_off INT DEFAULT NULL,
  percentage_laid_off TEXT,
  `date` TEXT,
  stage TEXT,
  country TEXT,
  funds_raised_millions INT DEFAULT NULL,
  row_num INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Insert rows with duplicate markers into new table
INSERT INTO copy_layoffs2
SELECT 
    *,
    ROW_NUMBER() OVER (
        PARTITION BY company, location, industry, total_laid_off, 
                     percentage_laid_off, `date`, stage, country, funds_raised_millions
    ) AS row_num
FROM copy_layoffs;

-- Delete duplicate rows (keep only row_num = 1)
DELETE 
FROM copy_layoffs2
WHERE row_num > 1;


-- =============================
-- STEP 3: STANDARDIZE TEXT DATA
-- =============================

-- Remove extra spaces from company names
UPDATE copy_layoffs2
SET company = TRIM(company);

-- Fix inconsistent country names (remove trailing ".")
UPDATE copy_layoffs2
SET country = TRIM(TRAILING '.' FROM country);

-- Preview cleaned country list
SELECT country 
FROM copy_layoffs2
GROUP BY country;


-- =============================
-- STEP 4: FIX DATE FORMATTING
-- =============================

-- Convert text-based date into MySQL DATE format
UPDATE copy_layoffs2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

-- Alter column to proper DATE type
ALTER TABLE copy_layoffs2
MODIFY COLUMN `date` DATE;


-- =============================
-- STEP 5: HANDLE MISSING VALUES
-- =============================

-- Standardize empty strings as NULL for industry
UPDATE copy_layoffs2
SET industry = NULL
WHERE industry = '';

-- Fill missing industry values using other rows from same company & country
UPDATE copy_layoffs2 t1
JOIN copy_layoffs2 t2
  ON t1.company = t2.company 
 AND t1.country = t2.country 
SET t1.industry = t2.industry
WHERE t1.industry IS NULL 
  AND t2.industry IS NOT NULL;

-- Check unresolved NULL industries
SELECT company, industry 
FROM copy_layoffs2 
WHERE industry IS NULL;


-- =============================
-- STEP 6: FINAL CLEANUP
-- =============================

-- Remove rows with no layoff data at all
DELETE 
FROM copy_layoffs2
WHERE total_laid_off IS NULL 
  AND percentage_laid_off IS NULL;

-- Drop helper column row_num (no longer needed)
ALTER TABLE copy_layoffs2
DROP COLUMN row_num;


-- =============================
-- DONE: CLEAN DATASET READY 
-- =============================
SELECT *
FROM copy_layoffs2;
