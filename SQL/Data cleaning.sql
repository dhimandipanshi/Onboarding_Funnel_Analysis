SELECT * FROM users
ORDER BY user_id;

SELECT * FROM events
ORDER BY user_id;

-- 1. Remove Duplicates
-- 4. Remove any columns 

-- Create a staging table so that the real ones doesnt get affected 
CREATE TABLE user_staging 
LIKE users;

SELECT * FROM user_staging
ORDER BY user_id;

INSERT INTO user_staging 
SELECT *
FROM users;

WITH duplicate_cte AS(
SELECT *,
ROW_NUMBER() 
OVER(PARTITION BY user_id, signup_time, email_verified_time , kyc_started_time,
kyc_approved_time , first_transaction_time, funnel_stage_reached, device_type, country, app_version, acquisition_channel) AS row_num
FROM user_staging)
SELECT *
FROM duplicate_cte 
WHERE row_num> 1;

CREATE TABLE `user_staging2` (
  `user_id` int DEFAULT NULL,
  `signup_time` text,
  `email_verified_time` text,
  `kyc_started_time` text,
  `kyc_approved_time` text,
  `first_transaction_time` text,
  `funnel_stage_reached` text,
  `device_type` text,
  `country` text,
  `app_version` text,
  `acquisition_channel` text ,
  `row_num` INT 
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT * FROM user_staging2;

INSERT INTO user_staging2
SELECT *,
ROW_NUMBER() 
OVER(PARTITION BY user_id, signup_time, email_verified_time , kyc_started_time,
kyc_approved_time , first_transaction_time, funnel_stage_reached, device_type, country, app_version, acquisition_channel) AS row_num
FROM user_staging  ;

DELETE 
FROM user_staging2
WHERE row_num >1;

-- 2. Standardise the Data

#TRIMMING THE SPACE
SELECT DISTINCT UPPER((TRIM(device_type)))
FROM user_staging2;

UPDATE user_staging2
SET device_type =UPPER(TRIM(device_type));

SELECT DISTINCT  UPPER((TRIM(country)))
FROM user_staging2;

UPDATE user_staging2
SET country = UPPER((TRIM(country)));

SELECT DISTINCT UPPER(funnel_stage_reached )
FROM user_staging2;

UPDATE user_staging2
SET funnel_stage_reached  = UPPER(funnel_stage_reached );

SELECT DISTINCT UPPER(TRIM(acquisition_channel))
FROM user_staging2;

UPDATE user_staging2
SET acquisition_channel  = UPPER(TRIM(acquisition_channel));

# slicicng the v from versions
UPDATE user_staging2
SET app_version = TRIM(
        REGEXP_REPLACE(
            REGEXP_REPLACE(app_version, '^[vV]', ''),
            '[[:space:]]', ''
        )
    )
WHERE app_version IS NOT NULL;

SELECT user_id,signup_time,
    STR_TO_DATE(signup_time, '%m/%d/%Y %H:%i:%s') as signup_time,
    STR_TO_DATE(NULLIF(email_verified_time, ''), '%m/%d/%Y %H:%i:%s') as email_verified_time,
    STR_TO_DATE(NULLIF( kyc_started_time, ''), '%m/%d/%Y %H:%i:%s') as  kyc_started_time,
    STR_TO_DATE(NULLIF( kyc_approved_time, ''), '%m/%d/%Y %H:%i:%s') as  kyc_approved_time,
    STR_TO_DATE(NULLIF( first_transaction_time, ''), '%m/%d/%Y %H:%i:%s') as  first_transaction_time
FROM user_staging2;

UPDATE user_staging2
SET 
    signup_time = STR_TO_DATE(signup_time, '%m/%d/%Y %H:%i:%s'),
    email_verified_time = STR_TO_DATE(NULLIF(email_verified_time, ''), '%m/%d/%Y %H:%i:%s'),
    kyc_started_time = STR_TO_DATE(NULLIF(kyc_started_time, ''), '%m/%d/%Y %H:%i:%s'),
    kyc_approved_time = STR_TO_DATE(NULLIF(kyc_approved_time, ''), '%m/%d/%Y %H:%i:%s'),
    first_transaction_time = STR_TO_DATE(NULLIF(first_transaction_time, ''), '%m/%d/%Y %H:%i:%s');

ALTER TABLE user_staging2
MODIFY COLUMN signup_time DATETIME,
MODIFY COLUMN email_verified_time DATETIME,
MODIFY COLUMN kyc_started_time DATETIME,
MODIFY COLUMN kyc_approved_time DATETIME,
MODIFY COLUMN first_transaction_time DATETIME;

SELECT * FROM user_staging2;

CREATE TABLE event_staging
LIKE events ;

INSERT INTO event_staging
SELECT *
FROM events ;

SELECT * FROM event_staging;

WITH duplicate_cte2 AS(
SELECT *, 
ROW_NUMBER() OVER(
PARTITION BY event_id, user_id, event_name , event_order, device_type, country) AS row_num
FROM event_staging
)
SELECT *
FROM duplicate_cte2
WHERE row_num >1;

CREATE TABLE `event_staging2` (
  `event_id` text,
  `user_id` int DEFAULT NULL,
  `event_name` text,
  `event_time` text,
  `event_order` int DEFAULT NULL,
  `device_type` text,
  `country` text,
  `kyc_status` text,
  `error_reason` text,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT *
FROM event_staging2
ORDER BY user_id;

INSERT INTO event_staging2
SELECT *, 
ROW_NUMBER() OVER(
PARTITION BY event_id, user_id, event_name , event_order, device_type, country) AS row_num
FROM event_staging;

SELECT * FROM event_staging2
WHERE row_num >1;

DELETE 
FROM event_staging2
WHERE row_num >1;

-- STANDRDISATION
UPDATE event_staging2
SET 
    event_time = STR_TO_DATE(event, '%m/%d/%Y %H:%i:%s');

UPDATE event_staging2
SET event_name = UPPER(TRIM(event_name));   

UPDATE event_staging2
SET device_type = UPPER(TRIM(device_type));  

UPDATE event_staging2
SET country = UPPER((TRIM(country)));  

ALTER TABLE event_staging2
MODIFY COLUMN event_time DATETIME;

ALTER TABLE user_staging2
DROP COLUMN row_num;

-- 3. Null Values or blank values
CREATE VIEW user_updated AS
SELECT
user_id,
  IFNULL(signup_time, 'Not completed')            AS signup_time,
  IFNULL(email_verified_time, 'Not completed')   AS email_verified_time,
  IFNULL(kyc_started_time, 'Not completed')      AS kyc_started_time,
  IFNULL(kyc_approved_time, 'Not completed')     AS kyc_approved_time,
  IFNULL(first_transaction_time, 'Not completed') AS first_transaction_time,
  funnel_stage_reached,
  device_type,
  country,
  app_version,
  acquisition_channel
FROM user_staging2;

SELECT * FROM user_updated;


SELECT * FROM event_staging2;
