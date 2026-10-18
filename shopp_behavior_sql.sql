use customer_analysis;
show tables;
SELECT * FROM shopping_behavior;
-- 1. Total Customers
SELECT COUNT(DISTINCT customer_id) AS total_customers
FROM shopping_behavior;

-- 2. Total Revenue
SELECT SUM(purchase_amount) AS total_revenue
FROM shopping_behavior;

-- 3. Total Orders/Transactions
SELECT COUNT(*) AS total_orders
FROM shopping_behavior;

-- 4. Average Order Value (AOV)
SELECT ROUND(AVG(purchase_amount), 2) AS avg_order_value
FROM shopping_behavior;

-- 5. Average Review Rating
SELECT ROUND(AVG(review_rating), 2) AS avg_review_rating
FROM shopping_behavior;

-- 6. Average Customer Age
SELECT ROUND(AVG(age), 1) AS avg_customer_age
FROM shopping_behavior;

-- 7. % Customers with Active Subscription
SELECT 
    ROUND(
        100.0 * SUM(CASE WHEN subscription_status = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 
        2
    ) AS subscription_rate_pct
FROM shopping_behavior;

-- 8. % Orders with Discount Applied
SELECT 
    ROUND(
        100.0 * SUM(CASE WHEN discount_applied = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 
        2
    ) AS discount_usage_pct
FROM shopping_behavior;

-- 9. Average Previous Purchases per Customer
SELECT ROUND(AVG(previous_purchases), 1) AS avg_previous_purchases
FROM shopping_behavior;

-- 10. All KPIs in ONE query (single row output)
SELECT 
    COUNT(DISTINCT customer_id)                                              AS total_customers,
    COUNT(*)                                                                  AS total_orders,
    SUM(purchase_amount)                                                      AS total_revenue,
    ROUND(AVG(purchase_amount), 2)                                            AS avg_order_value,
    ROUND(AVG(review_rating), 2)                                              AS avg_review_rating,
    ROUND(100.0 * SUM(CASE WHEN subscription_status='Yes' THEN 1 ELSE 0 END)/COUNT(*), 2) AS subscription_rate_pct,
    ROUND(100.0 * SUM(CASE WHEN discount_applied='Yes' THEN 1 ELSE 0 END)/COUNT(*), 2)    AS discount_usage_pct
FROM shopping_behavior;
-- 11. gender wise revenue with % share and AOV
SELECT 
    gender,
    COUNT(*)                                   AS total_orders,
    SUM(purchase_amount)                       AS total_revenue,
    ROUND(AVG(purchase_amount), 2)             AS avg_order_value,
    ROUND(
        100.0 * SUM(purchase_amount) / SUM(SUM(purchase_amount)) OVER (), 
        2
    )                                           AS revenue_pct_share
FROM shopping_behavior
GROUP BY gender
ORDER BY total_revenue DESC;
-- 12. Category-wise Revenue
SELECT 
    category,
    COUNT(*)                                   AS total_orders,
    SUM(purchase_amount)                       AS total_revenue,
    ROUND(AVG(purchase_amount), 2)             AS avg_order_value,
    ROUND(
        100.0 * SUM(purchase_amount) / SUM(SUM(purchase_amount)) OVER (), 
        2
    )                                           AS revenue_pct_share
FROM shopping_behavior
GROUP BY category
ORDER BY total_revenue DESC;
-- 12. Season-wise Revenue
SELECT 
    season,
    COUNT(*)                                   AS total_orders,
    SUM(purchase_amount)                       AS total_revenue,
    ROUND(AVG(purchase_amount), 2)             AS avg_order_value,
    ROUND(
        100.0 * SUM(purchase_amount) / SUM(SUM(purchase_amount)) OVER (), 
        2
    )                                           AS revenue_pct_share
FROM shopping_behavior
GROUP BY season
ORDER BY total_revenue DESC;

-- 13. Location-wise Revenue (Top 10 — poori list dikhani ho toh LIMIT hata dena)
SELECT 
    location,
    COUNT(*)                                   AS total_orders,
    SUM(purchase_amount)                       AS total_revenue,
    ROUND(AVG(purchase_amount), 2)             AS avg_order_value,
    ROUND(
        100.0 * SUM(purchase_amount) / SUM(SUM(purchase_amount)) OVER (), 
        2
    )                                           AS revenue_pct_share
FROM shopping_behavior
GROUP BY location
ORDER BY total_revenue DESC
LIMIT 10;
-- 14. Subscription Status - Overall Breakdown (Revenue, Orders, AOV)

-- 15. Overall Impact: Revenue, AOV, Rating by Discount
SELECT 
    discount_applied,
    COUNT(*)                                   AS total_orders,
    SUM(purchase_amount)                       AS total_revenue,
    ROUND(AVG(purchase_amount), 2)             AS avg_order_value,
    ROUND(AVG(review_rating), 2)               AS avg_review_rating,
    ROUND(AVG(previous_purchases), 2)          AS avg_previous_purchases
FROM shopping_behavior
GROUP BY discount_applied;
-- 16. Product-wise Revenue (all 25 products)
SELECT 
    item_purchased,
    category,
    COUNT(*)                                   AS total_orders,
    SUM(purchase_amount)                       AS total_revenue,
    ROUND(AVG(purchase_amount), 2)             AS avg_order_value,
    ROUND(
        100.0 * SUM(purchase_amount) / SUM(SUM(purchase_amount)) OVER (), 
        2
    )                                           AS revenue_pct_share
FROM shopping_behavior
GROUP BY item_purchased, category
ORDER BY total_revenue DESC;

-- 17. Age Group-wise Revenue (with CASE statement for bucketing)
SELECT 
    CASE 
        WHEN age BETWEEN 18 AND 25 THEN '18-25'
        WHEN age BETWEEN 26 AND 35 THEN '26-35'
        WHEN age BETWEEN 36 AND 45 THEN '36-45'
        WHEN age BETWEEN 46 AND 55 THEN '46-55'
        WHEN age BETWEEN 56 AND 65 THEN '56-65'
        ELSE '66+'
    END AS age_group,
    COUNT(*)                                   AS total_orders,
    SUM(purchase_amount)                       AS total_revenue,
    ROUND(AVG(purchase_amount), 2)             AS avg_order_value,
    ROUND(AVG(review_rating), 2)               AS avg_review_rating,
    ROUND(
        100.0 * SUM(purchase_amount) / SUM(SUM(purchase_amount)) OVER (), 
        2
    )                                           AS revenue_pct_share
FROM shopping_behavior
GROUP BY 
    CASE 
        WHEN age BETWEEN 18 AND 25 THEN '18-25'
        WHEN age BETWEEN 26 AND 35 THEN '26-35'
        WHEN age BETWEEN 36 AND 45 THEN '36-45'
        WHEN age BETWEEN 46 AND 55 THEN '46-55'
        WHEN age BETWEEN 56 AND 65 THEN '56-65'
        ELSE '66+'
    END
ORDER BY age_group;

-- 18.  Add purchase_frequency_days column based on frequency_of_purchases
SELECT 
    *,
    CASE frequency_of_purchases
        WHEN 'Weekly'         THEN 7
        WHEN 'Fortnightly'    THEN 14
        WHEN 'Bi-Weekly'      THEN 14
        WHEN 'Monthly'        THEN 30
        WHEN 'Every 3 Months' THEN 90
        WHEN 'Quarterly'      THEN 90
        WHEN 'Annually'       THEN 365
        ELSE NULL
    END AS purchase_frequency_days
FROM shopping_behavior;