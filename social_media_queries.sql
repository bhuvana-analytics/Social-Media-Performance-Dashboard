
-- =========================================================
-- PROJECT: SOCIAL MEDIA PERFORMANCE DASHBOARD
-- SQL FOR DATA ANALYTICS PROJECT
-- =========================================================



-- =========================================================
-- STEP 1: CREATE DATABASE
-- PURPOSE:
-- Creates a new database for the project
-- =========================================================

CREATE DATABASE SOCIAL_MEDIA_PERFORMANCE_DASHBOARD;



-- =========================================================
-- STEP 2: USE DATABASE
-- PURPOSE:
-- Selects the database to work on
-- =========================================================

USE SOCIAL_MEDIA_PERFORMANCE_DASHBOARD;



-- =========================================================
-- STEP 3: SHOW TABLES
-- PURPOSE:
-- Displays all tables inside database
-- =========================================================

SHOW TABLES;



-- =========================================================
-- STEP 4: VIEW COMPLETE DATA
-- PURPOSE:
-- Displays all rows and columns from dataset
-- =========================================================

SELECT * 
FROM social_media_performance_dataset;



-- =========================================================
-- STEP 5: CHECK TABLE STRUCTURE
-- PURPOSE:
-- Displays column names and data types
-- =========================================================

DESCRIBE social_media_performance_dataset;



-- =========================================================
-- STEP 6: PREVIEW DATETIME CONVERSION
-- PURPOSE:
-- Converts text datetime into SQL datetime format
-- WITHOUT changing original data
-- =========================================================

SELECT 
    post_datetime,
    STR_TO_DATE(post_datetime, '%m/%d/%Y %H:%i') AS converted_datetime
FROM social_media_performance_dataset;



-- =========================================================
-- STEP 7: DISABLE SAFE UPDATE MODE
-- PURPOSE:
-- Allows updating all rows safely
-- =========================================================

SET SQL_SAFE_UPDATES = 0;



-- =========================================================
-- STEP 8: CONVERT TEXT DATETIME TO REAL DATETIME
-- PURPOSE:
-- Updates post_datetime column into SQL datetime format
-- =========================================================

UPDATE social_media_performance_dataset
SET post_datetime = STR_TO_DATE(post_datetime, '%m/%d/%Y %H:%i')
WHERE post_id IS NOT NULL;



-- =========================================================
-- STEP 9: CHANGE DATATYPE TO DATETIME
-- PURPOSE:
-- Converts column datatype from TEXT to DATETIME
-- =========================================================

ALTER TABLE social_media_performance_dataset
MODIFY post_datetime DATETIME;



-- =========================================================
-- STEP 10: ADD DATE & TIME COLUMNS
-- PURPOSE:
-- Creates separate date and time columns
-- =========================================================

ALTER TABLE social_media_performance_dataset
ADD post_date DATE,
ADD post_time TIME;



-- =========================================================
-- STEP 11: FILL DATE & TIME VALUES
-- PURPOSE:
-- Extracts date and time from post_datetime
-- =========================================================

UPDATE social_media_performance_dataset
SET 
    post_date = DATE(post_datetime),
    post_time = TIME(post_datetime)
WHERE post_datetime IS NOT NULL;



-- =========================================================
-- STEP 12: ADD FOLLOWERS COLUMN
-- PURPOSE:
-- Creates followers column for analytics
-- =========================================================

ALTER TABLE social_media_performance_dataset
ADD followers INT;



-- =========================================================
-- STEP 13: GENERATE FOLLOWERS VALUES
-- PURPOSE:
-- Creates followers count based on engagement rate
-- =========================================================

UPDATE social_media_performance_dataset
SET followers = FLOOR(engagement_rate * 10000);



-- =========================================================
-- STEP 14: CHECK NULL VALUES
-- PURPOSE:
-- Finds missing values in important columns
-- =========================================================

SELECT *
FROM social_media_performance_dataset
WHERE platform IS NULL
   OR content_type IS NULL
   OR likes IS NULL
   OR views IS NULL
   OR engagement_rate IS NULL;



-- =========================================================
-- STEP 15: CHECK BLANK VALUES
-- PURPOSE:
-- Finds empty text values
-- =========================================================

SELECT *
FROM social_media_performance_dataset
WHERE platform = ''
   OR content_type = ''
   OR topic = '';



-- =========================================================
-- STEP 16: CHECK DUPLICATES
-- PURPOSE:
-- Finds duplicate post IDs
-- =========================================================

SELECT 
    post_id,
    COUNT(*) AS duplicate_count
FROM social_media_performance_dataset
GROUP BY post_id
HAVING COUNT(*) > 1;



-- =========================================================
-- STEP 17: CHECK INVALID DATA
-- PURPOSE:
-- Finds negative or invalid values
-- =========================================================

SELECT *
FROM social_media_performance_dataset
WHERE likes < 0
   OR views < 0
   OR engagement_rate < 0;



-- =========================================================
-- STEP 18: CHECK EXTRA SPACES
-- PURPOSE:
-- Finds unwanted spaces in platform column
-- =========================================================

SELECT platform
FROM social_media_performance_dataset
WHERE platform LIKE ' %'
   OR platform LIKE '% ';



-- =========================================================
-- STEP 19: REMOVE EXTRA SPACES
-- PURPOSE:
-- Cleans text values using TRIM
-- =========================================================
SET SQL_SAFE_UPDATES = 0;

UPDATE social_media_performance_dataset
SET platform = TRIM(platform)
WHERE post_id IS NOT NULL;


-- =========================================================
-- STEP 20: ADD ENGAGEMENT LEVEL COLUMN
-- PURPOSE:
-- Creates engagement category column
-- =========================================================

ALTER TABLE social_media_performance_dataset
ADD engagement_level VARCHAR(20);



-- =========================================================
-- STEP 21: FILL ENGAGEMENT LEVEL VALUES
-- PURPOSE:
-- Categorizes posts into HIGH / MEDIUM / LOW
-- =========================================================

UPDATE social_media_performance_dataset
SET engagement_level =
CASE
    WHEN engagement_rate >= 0.50 THEN 'HIGH'
    WHEN engagement_rate >= 0.20 THEN 'MEDIUM'
    ELSE 'LOW'
END;



-- =========================================================
-- STEP 22: COUNT POSTS BY PLATFORM
-- PURPOSE:
-- Counts total posts on each platform
-- =========================================================

SELECT 
    platform,
    COUNT(*) AS total_posts
FROM social_media_performance_dataset
GROUP BY platform;



-- =========================================================
-- STEP 23: AVERAGE ENGAGEMENT BY PLATFORM
-- PURPOSE:
-- Finds average engagement for each platform
-- =========================================================

SELECT 
    platform,
    AVG(engagement_rate) AS avg_engagement
FROM social_media_performance_dataset
GROUP BY platform;



-- =========================================================
-- STEP 24: TOTAL LIKES BY PLATFORM
-- PURPOSE:
-- Calculates total likes for each platform
-- =========================================================

SELECT 
    platform,
    SUM(likes) AS total_likes
FROM social_media_performance_dataset
GROUP BY platform;



-- =========================================================
-- STEP 25: TOP 5 MOST LIKED POSTS
-- PURPOSE:
-- Displays highest liked posts
-- =========================================================

SELECT 
    post_id,
    platform,
    likes
FROM social_media_performance_dataset
ORDER BY likes DESC
LIMIT 5;



-- =========================================================
-- STEP 26: VIRAL POSTS BY PLATFORM
-- PURPOSE:
-- Counts viral posts on each platform
-- =========================================================

SELECT 
    platform,
    COUNT(*) AS viral_posts
FROM social_media_performance_dataset
WHERE is_viral = 1
GROUP BY platform;



-- =========================================================
-- STEP 27: BEST CONTENT TYPE BY ENGAGEMENT
-- PURPOSE:
-- Finds best performing content type
-- =========================================================

SELECT 
    content_type,
    AVG(engagement_rate) AS avg_engagement
FROM social_media_performance_dataset
GROUP BY content_type
ORDER BY avg_engagement DESC;



-- =========================================================
-- STEP 28: POSTS BY ENGAGEMENT LEVEL
-- PURPOSE:
-- Counts LOW / MEDIUM / HIGH engagement posts
-- =========================================================

SELECT 
    engagement_level,
    COUNT(*) AS total_posts
FROM social_media_performance_dataset
GROUP BY engagement_level;

-- =====================================================
-- PLATFORMS WITH AVG LIKES GREATER THAN 5000
-- =====================================================

SELECT 
    platform,
    AVG(likes) AS avg_likes
FROM social_media_performance_dataset
GROUP BY platform
HAVING AVG(likes) > 5000;

-- =====================================================
-- CONTENT TYPES WITH TOTAL VIEWS GREATER THAN 1,000,000
-- =====================================================

SELECT 
    content_type,
    SUM(views) AS total_views
FROM social_media_performance_dataset
GROUP BY content_type
HAVING SUM(views) > 1000000;

-- =====================================================
-- PLATFORMS WITH MORE THAN 100 POSTS
-- =====================================================

SELECT 
    platform,
    COUNT(*) AS total_posts
FROM social_media_performance_dataset
GROUP BY platform
HAVING COUNT(*) > 100;

-- =========================================================
-- STEP 29: BEST POSTING HOUR
-- PURPOSE:
-- Finds which posting hour gets highest engagement
-- =========================================================

SELECT 
    HOUR(post_time) AS posting_hour,
    AVG(engagement_rate) AS avg_engagement
FROM social_media_performance_dataset
GROUP BY posting_hour
ORDER BY avg_engagement DESC;



-- =========================================================
-- STEP 30: POSTS BY MONTH
-- PURPOSE:
-- Counts total posts uploaded each month
-- =========================================================

SELECT 
    MONTH(post_date) AS month_number,
    COUNT(*) AS total_posts
FROM social_media_performance_dataset
GROUP BY month_number
ORDER BY month_number;



-- =========================================================
-- STEP 31: BEST DAY BY ENGAGEMENT
-- PURPOSE:
-- Finds which day gets highest engagement
-- =========================================================

SELECT 
    DAYNAME(post_date) AS day_name,
    AVG(engagement_rate) AS avg_engagement
FROM social_media_performance_dataset
GROUP BY day_name
ORDER BY avg_engagement DESC;



-- =========================================================
-- STEP 32: VIRAL POSTS BY REGION
-- PURPOSE:
-- Counts viral posts in each region
-- =========================================================

SELECT 
    region,
    COUNT(*) AS viral_posts
FROM social_media_performance_dataset
WHERE is_viral = 1
GROUP BY region
ORDER BY viral_posts DESC;



-- =========================================================
-- STEP 33: TOP 10 POSTS BY ENGAGEMENT
-- PURPOSE:
-- Displays top performing posts
-- =========================================================

SELECT 
    post_id,
    platform,
    content_type,
    engagement_rate
FROM social_media_performance_dataset
ORDER BY engagement_rate DESC
LIMIT 10;



-- =========================================================
-- STEP 34: ADD FOLLOWER CATEGORY COLUMN
-- PURPOSE:
-- Creates follower category column
-- =========================================================

ALTER TABLE social_media_performance_dataset
ADD follower_category VARCHAR(20);



-- =========================================================
-- STEP 35: FILL FOLLOWER CATEGORY VALUES
-- PURPOSE:
-- Categorizes accounts by followers
-- =========================================================

UPDATE social_media_performance_dataset
SET follower_category =
CASE
    WHEN followers >= 7000 THEN 'INFLUENCER'
    WHEN followers >= 3000 THEN 'GROWING'
    ELSE 'SMALL'
END;



-- =========================================================
-- STEP 36: POSTS BY FOLLOWER CATEGORY
-- PURPOSE:
-- Counts posts by follower category
-- =========================================================

SELECT 
    follower_category,
    COUNT(*) AS total_posts
FROM social_media_performance_dataset
GROUP BY follower_category;



-- =========================================================
-- STEP 37: AVERAGE LIKES BY FOLLOWER CATEGORY
-- PURPOSE:
-- Finds average likes for each follower category
-- =========================================================

SELECT 
    follower_category,
    AVG(likes) AS avg_likes
FROM social_media_performance_dataset
GROUP BY follower_category
ORDER BY avg_likes DESC;



-- =========================================================
-- STEP 38: TOTAL SHARES BY PLATFORM
-- PURPOSE:
-- Calculates total shares for each platform
-- =========================================================

SELECT 
    platform,
    SUM(shares) AS total_shares
FROM social_media_performance_dataset
GROUP BY platform
ORDER BY total_shares DESC;



-- =========================================================
-- STEP 39: TOP REGIONS BY AVG ENGAGEMENT
-- PURPOSE:
-- Finds highest engaged regions
-- =========================================================

SELECT 
    region,
    AVG(engagement_rate) AS avg_engagement
FROM social_media_performance_dataset
GROUP BY region
ORDER BY avg_engagement DESC;



-- =========================================================
-- STEP 40: CONTENT TYPE PERFORMANCE ANALYSIS
-- PURPOSE:
-- Shows overall performance metrics by content type
-- =========================================================

SELECT 
    content_type,
    COUNT(*) AS total_posts,
    AVG(likes) AS avg_likes,
    AVG(comments) AS avg_comments,
    AVG(shares) AS avg_shares,
    AVG(engagement_rate) AS avg_engagement
FROM social_media_performance_dataset
GROUP BY content_type
ORDER BY avg_engagement DESC;

-- =========================================================
-- STEP 41: POSTS ABOVE AVERAGE LIKES
-- PURPOSE:
-- Finds posts having likes greater than average likes
-- =========================================================

SELECT 
    post_id,
    platform,
    likes
FROM social_media_performance_dataset
WHERE likes > (
    SELECT AVG(likes)
    FROM social_media_performance_dataset
);



-- =========================================================
-- STEP 42: PLATFORM WITH HIGHEST AVG ENGAGEMENT
-- PURPOSE:
-- Finds best performing platform
-- =========================================================

SELECT 
    platform,
    AVG(engagement_rate) AS avg_engagement
FROM social_media_performance_dataset
GROUP BY platform
HAVING AVG(engagement_rate) = (
    SELECT MAX(avg_engagement)
    FROM (
        SELECT AVG(engagement_rate) AS avg_engagement
        FROM social_media_performance_dataset
        GROUP BY platform
    ) AS temp_table
);



-- =========================================================
-- STEP 43: POSTS WITH ABOVE-AVERAGE ENGAGEMENT
-- PURPOSE:
-- Finds high-performing posts
-- =========================================================

SELECT 
    post_id,
    platform,
    engagement_rate
FROM social_media_performance_dataset
WHERE engagement_rate > (
    SELECT AVG(engagement_rate)
    FROM social_media_performance_dataset
)
ORDER BY engagement_rate DESC;



-- =========================================================
-- STEP 44: REGIONS ABOVE AVERAGE VIEWS
-- PURPOSE:
-- Finds regions performing above average
-- =========================================================

SELECT 
    region,
    AVG(views) AS avg_views
FROM social_media_performance_dataset
GROUP BY region
HAVING AVG(views) > (
    SELECT AVG(views)
    FROM social_media_performance_dataset
);



-- =========================================================
-- STEP 45: MOST LIKED POST
-- PURPOSE:
-- Finds post with maximum likes
-- =========================================================

SELECT 
    post_id,
    platform,
    likes
FROM social_media_performance_dataset
WHERE likes = (
    SELECT MAX(likes)
    FROM social_media_performance_dataset
);



-- =========================================================
-- STEP 46: ROW NUMBER BY ENGAGEMENT
-- PURPOSE:
-- Assigns unique row number based on engagement rate
-- =========================================================

SELECT 
    post_id,
    platform,
    engagement_rate,
    ROW_NUMBER() OVER (
        ORDER BY engagement_rate DESC
    ) AS row_num
FROM social_media_performance_dataset;



-- =========================================================
-- STEP 47: RANK POSTS BY LIKES
-- PURPOSE:
-- Assigns ranking based on likes
-- =========================================================

SELECT 
    post_id,
    platform,
    likes,
    RANK() OVER (
        ORDER BY likes DESC
    ) AS post_rank
FROM social_media_performance_dataset;



-- =========================================================
-- STEP 48: DENSE RANK BY ENGAGEMENT
-- PURPOSE:
-- Ranks posts without skipping numbers
-- =========================================================

SELECT 
    post_id,
    platform,
    engagement_rate,
    DENSE_RANK() OVER (
        ORDER BY engagement_rate DESC
    ) AS dense_rank_num
FROM social_media_performance_dataset;



-- =========================================================
-- STEP 49: TOP POSTS PER PLATFORM
-- PURPOSE:
-- Finds top engagement post from each platform
-- =========================================================

SELECT *
FROM (
    SELECT 
        post_id,
        platform,
        engagement_rate,
        ROW_NUMBER() OVER (
            PARTITION BY platform
            ORDER BY engagement_rate DESC
        ) AS rn
    FROM social_media_performance_dataset
) ranked_posts
WHERE rn = 1;



-- =========================================================
-- STEP 50: RUNNING TOTAL OF LIKES
-- PURPOSE:
-- Calculates cumulative likes
-- =========================================================

SELECT 
    post_id,
    likes,
    SUM(likes) OVER (
        ORDER BY post_id
    ) AS running_total_likes
FROM social_media_performance_dataset;



-- =========================================================
-- STEP 51: CREATE CREATORS TABLE
-- PURPOSE:
-- Creates creator information table
-- =========================================================

CREATE TABLE creators (
    creator_id INT PRIMARY KEY,
    creator_name VARCHAR(100),
    platform VARCHAR(50),
    country VARCHAR(50)
);



-- =========================================================
-- STEP 52: INSERT SAMPLE CREATOR DATA
-- PURPOSE:
-- Adds sample creator records
-- =========================================================

INSERT INTO creators VALUES
(1, 'Aarav', 'Instagram', 'India'),
(2, 'Sophia', 'Twitter', 'USA'),
(3, 'Rohan', 'Facebook', 'India'),
(4, 'Emma', 'Instagram', 'UK'),
(5, 'Liam', 'LinkedIn', 'Canada');



-- =========================================================
-- STEP 53: ADD creator_id COLUMN
-- PURPOSE:
-- Adds creator_id into main table
-- =========================================================

ALTER TABLE social_media_performance_dataset
ADD creator_id INT;



-- =========================================================
-- STEP 54: ASSIGN CREATOR IDs
-- PURPOSE:
-- Assigns creator IDs for join practice
-- =========================================================

UPDATE social_media_performance_dataset
SET creator_id =
CASE
    WHEN platform = 'Instagram' THEN 1
    WHEN platform = 'Twitter' THEN 2
    WHEN platform = 'Facebook' THEN 3
    ELSE 5
END;



-- =========================================================
-- STEP 55: INNER JOIN
-- PURPOSE:
-- Combines matching rows from both tables
-- =========================================================

SELECT 
    s.post_id,
    s.platform,
    s.likes,
    c.creator_name,
    c.country
FROM social_media_performance_dataset s
INNER JOIN creators c
ON s.creator_id = c.creator_id;



-- =========================================================
-- STEP 56: LEFT JOIN
-- PURPOSE:
-- Shows all rows from left table
-- =========================================================

SELECT 
    s.post_id,
    s.platform,
    c.creator_name
FROM social_media_performance_dataset s
LEFT JOIN creators c
ON s.creator_id = c.creator_id;



-- =========================================================
-- STEP 57: AVG LIKES BY CREATOR
-- PURPOSE:
-- Calculates creator performance
-- =========================================================

SELECT 
    c.creator_name,
    AVG(s.likes) AS avg_likes
FROM social_media_performance_dataset s
INNER JOIN creators c
ON s.creator_id = c.creator_id
GROUP BY c.creator_name
ORDER BY avg_likes DESC;

SELECT *
FROM social_media_performance_dataset;
