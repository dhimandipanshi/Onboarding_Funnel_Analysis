/* =========================================================
   FUNNEL ANALYSIS — EXPLORATORY DATA ANALYSIS
   Dataset: user_staging2, event_staging2
   Purpose: Understand user progression, conversion, and drop-offs
========================================================= */

-- =========================================================
-- 1. DATA OVERVIEW
-- =========================================================

-- Total users
SELECT COUNT(DISTINCT user_id) AS total_users
FROM user_staging2;

-- Available event types
SELECT DISTINCT event_name
FROM event_staging2
ORDER BY event_name;


-- =========================================================
-- 2. FUNNEL STAGE COUNTS (CUMULATIVE)
-- =========================================================

SELECT 'Signed Up' AS funnel_stage, COUNT(DISTINCT user_id) AS users
FROM user_staging2
WHERE signup_time IS NOT NULL

UNION ALL
SELECT 'Email Verified', COUNT(DISTINCT user_id)
FROM user_staging2
WHERE email_verified_time IS NOT NULL

UNION ALL
SELECT 'KYC Started', COUNT(DISTINCT user_id)
FROM user_staging2
WHERE kyc_started_time IS NOT NULL

UNION ALL
SELECT 'KYC Approved', COUNT(DISTINCT user_id)
FROM user_staging2
WHERE kyc_approved_time IS NOT NULL

UNION ALL
SELECT 'Transaction Completed', COUNT(DISTINCT user_id)
FROM user_staging2
WHERE first_transaction_time IS NOT NULL;


-- =========================================================
-- 3. FUNNEL CONVERSION PERCENTAGES
-- =========================================================

SELECT
  COUNT(DISTINCT user_id) AS total_users,
  ROUND(100.0 * COUNT(DISTINCT CASE WHEN email_verified_time IS NOT NULL THEN user_id END) 
        / COUNT(DISTINCT user_id), 2) AS email_verification_rate,
  ROUND(100.0 * COUNT(DISTINCT CASE WHEN kyc_started_time IS NOT NULL THEN user_id END) 
        / COUNT(DISTINCT user_id), 2) AS kyc_start_rate,
  ROUND(100.0 * COUNT(DISTINCT CASE WHEN kyc_approved_time IS NOT NULL THEN user_id END) 
        / COUNT(DISTINCT user_id), 2) AS kyc_approval_rate,
  ROUND(100.0 * COUNT(DISTINCT CASE WHEN first_transaction_time IS NOT NULL THEN user_id END) 
        / COUNT(DISTINCT user_id), 2) AS transaction_completion_rate
FROM user_staging2;


-- =========================================================
-- 4. CONVERSION BY DEVICE TYPE
-- =========================================================

SELECT
  device_type,
  COUNT(DISTINCT user_id) AS total_users,
  COUNT(DISTINCT CASE WHEN first_transaction_time IS NOT NULL THEN user_id END) AS completed_users,
  ROUND(
    100.0 * COUNT(DISTINCT CASE WHEN first_transaction_time IS NOT NULL THEN user_id END)
    / COUNT(DISTINCT user_id),
    2
  ) AS conversion_rate
FROM user_staging2
GROUP BY device_type
ORDER BY conversion_rate DESC;


-- =========================================================
-- 5. CONVERSION BY ACQUISITION CHANNEL
-- =========================================================

SELECT
  acquisition_channel,
  COUNT(DISTINCT user_id) AS total_users,
  COUNT(DISTINCT CASE WHEN first_transaction_time IS NOT NULL THEN user_id END) AS completed_users,
  ROUND(
    100.0 * COUNT(DISTINCT CASE WHEN first_transaction_time IS NOT NULL THEN user_id END)
    / COUNT(DISTINCT user_id),
    2
  ) AS conversion_rate
FROM user_staging2
GROUP BY acquisition_channel
ORDER BY conversion_rate DESC, total_users DESC;


-- =========================================================
-- 6. TOP COUNTRIES BY USER COUNT
-- =========================================================

SELECT
  country,
  COUNT(DISTINCT user_id) AS user_count
FROM user_staging2
GROUP BY country
ORDER BY user_count DESC
LIMIT 5;


-- =========================================================
-- 7. MONTHLY SIGNUP TREND
-- =========================================================

SELECT
  DATE_FORMAT(signup_time, '%Y-%m') AS signup_month,
  COUNT(DISTINCT user_id) AS signups
FROM user_staging2
WHERE signup_time IS NOT NULL
GROUP BY signup_month
ORDER BY signup_month;


-- =========================================================
-- 8. EVENT-LEVEL EXECUTIVE SUMMARY
-- =========================================================

SELECT
  COUNT(*) AS total_events,
  COUNT(DISTINCT user_id) AS unique_users,
  COUNT(DISTINCT event_name) AS event_types,
  ROUND(COUNT(*) / COUNT(DISTINCT user_id), 2) AS avg_events_per_user,
  COUNT(CASE WHEN error_reason IS NOT NULL THEN 1 END) AS total_errors,
  ROUND(
    100.0 * COUNT(CASE WHEN error_reason IS NOT NULL THEN 1 END) / COUNT(*),
    2
  ) AS error_rate,
  COUNT(DISTINCT CASE 
        WHEN LOWER(event_name) LIKE '%transaction_completed%' THEN user_id 
      END) AS transacting_users,
  ROUND(
    100.0 * COUNT(DISTINCT CASE 
        WHEN LOWER(event_name) LIKE '%transaction_completed%' THEN user_id 
      END) / COUNT(DISTINCT user_id),
    2
  ) AS event_based_completion_rate
FROM event_staging2;

-- =========================================================
-- 9. DROP-OFFS
-- =========================================================
SELECT
  COUNT(DISTINCT user_id) AS signed_up,
  COUNT(DISTINCT CASE WHEN email_verified_time IS NOT NULL THEN user_id END) AS email_verified,
  COUNT(DISTINCT CASE WHEN kyc_started_time IS NOT NULL THEN user_id END) AS kyc_started,
  COUNT(DISTINCT CASE WHEN kyc_approved_time IS NOT NULL THEN user_id END) AS kyc_approved,
  COUNT(DISTINCT CASE WHEN first_transaction_time IS NOT NULL THEN user_id END) AS transacted
FROM user_staging2;

-- =========================================================
-- 10. TIMSETAMP
-- =========================================================
SELECT
  AVG(TIMESTAMPDIFF(HOUR, signup_time, email_verified_time)) AS avg_hours_to_email,
  AVG(TIMESTAMPDIFF(HOUR, email_verified_time, kyc_started_time)) AS avg_hours_to_kyc_start,
  AVG(TIMESTAMPDIFF(HOUR, kyc_approved_time, first_transaction_time)) AS avg_hours_to_transaction
FROM user_staging2
WHERE first_transaction_time IS NOT NULL;


SELECT  event_name,
COUNT(*) AS occurance
FROM event_staging2
GROUP BY event_name
HAVING event_name IS NOT NULL
ORDER BY occurance;
