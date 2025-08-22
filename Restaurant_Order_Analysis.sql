-- --------------------------------------------------
-- Import Large Database in a Faster Way 
-- --------------------------------------------------

-- Step 1: Create and select the database
CREATE DATABASE Restaurant_Order_Analysis;
USE Restaurant_Order_Analysis;

-- Step 2: Create the order_details table
CREATE TABLE order_details 
(
    order_details_id INT,
    order_id INT, 
    order_date DATE,
    order_time TIME,
    item_id INT
);

-- Step 3: Enable local infile (needed to load CSV files into MySQL)
SET GLOBAL local_infile = 1;

-- Step 4: Load data into order_details table from CSV
-- Note: Adjust the file path depending on your system
LOAD DATA LOCAL INFILE 'C:\\Users\\pc\\OneDrive\\Desktop\\Portfolio\\order_details.csv'
INTO TABLE order_details
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;

-- Quick check: Verify that data was loaded correctly
SELECT * 
FROM order_details;

-- --------------------------------------------------
-- Objective 1: Explore the menu_items table
-- --------------------------------------------------

-- View all rows from menu_items (sanity check)
SELECT * 
FROM menu_items;

-- Count how many menu items exist
SELECT COUNT(item_name) AS number_of_items
FROM menu_items;

-- Find the most expensive item on the menu
SELECT item_name, price
FROM menu_items
ORDER BY price DESC
LIMIT 1;

-- Find the least expensive item on the menu
SELECT item_name, price
FROM menu_items
ORDER BY price ASC
LIMIT 1;

-- --------------------------------------------------
-- Summary statistics for the menu
-- --------------------------------------------------

-- Get total items, average price, max price, min price
SELECT  
    COUNT(*) AS total_items, 
    ROUND(AVG(price), 2) AS avg_price,
    MAX(price) AS most_expensive,
    MIN(price) AS least_expensive
FROM menu_items;

-- --------------------------------------------------
-- Filter and explore specific categories
-- --------------------------------------------------

-- Count how many Italian dishes are on the menu
SELECT COUNT(*) AS italian_dishes
FROM menu_items
WHERE category = 'Italian';

-- Find least and most expensive Italian dishes
SELECT 
    category, 
    MAX(price) AS most_expensive_italian, 
    MIN(price) AS least_expensive_italian
FROM menu_items
GROUP BY category
HAVING category = 'Italian';

-- Find number of dishes in each category and their average price
SELECT category, COUNT(*) AS num_items, ROUND(AVG(price),2) AS average_price
FROM menu_items
GROUP BY category;

-- Found a mistake in a column name when importing → fix it
ALTER TABLE menu_items
RENAME COLUMN ï»¿menu_item_id TO menu_item_id;

-- --------------------------------------------------
-- Objective 2: Analyze Customer Behavior
-- --------------------------------------------------

-- Inspect the tables
SELECT * FROM menu_items;
SELECT * FROM order_details;

-- --------------------------------------------------
-- Fix bug: Some rows have invalid date '0000-00-00' in order_date
-- --------------------------------------------------

-- Step 1: Relax sql_mode temporarily to allow invalid dates
SET sql_mode = REPLACE(@@sql_mode, 'STRICT_TRANS_TABLES', '');
SET sql_mode = REPLACE(@@sql_mode, 'NO_ZERO_DATE', '');

-- Step 2: Replace invalid dates with NULL
UPDATE order_details
SET order_date = NULL
WHERE order_date = '0000-00-00';

-- Step 3: Restore sql_mode to original strict settings
SET sql_mode = CONCAT(@@sql_mode, ',STRICT_TRANS_TABLES,NO_ZERO_DATE');

-- --------------------------------------------------
-- Create a join table for analysis (combine menu_items and order_details)
-- --------------------------------------------------

CREATE TABLE join_table AS
SELECT *
FROM menu_items t1
JOIN order_details t2  
    ON t1.menu_item_id = t2.item_id;

-- Inspect the joined table
SELECT * FROM join_table;

-- --------------------------------------------------
-- Customer behavior analysis
-- --------------------------------------------------

-- Find the most popular items (count orders per item/category)
SELECT item_name, category, COUNT(order_details_id) AS the_number_of_orders 
FROM join_table
GROUP BY item_name, category
ORDER BY the_number_of_orders;

-- Find the top 5 highest spending orders
SELECT order_id, SUM(price) AS total_spent_by_order 
FROM join_table
GROUP BY order_id
ORDER BY total_spent_by_order DESC 
LIMIT 5;

-- View details of a specific order (example: order_id = 440)
SELECT *
FROM join_table
WHERE order_id = 440;

-- Find category distribution within a single order (example: 440)
SELECT category, COUNT(order_details_id) AS category_count
FROM join_table
WHERE order_id = 440
GROUP BY category;

-- Find category distribution across multiple top orders
SELECT order_id, category, COUNT(item_id) AS items_count
FROM join_table
WHERE order_id IN (440,2075,1957,330,2675)
GROUP BY order_id, category;
