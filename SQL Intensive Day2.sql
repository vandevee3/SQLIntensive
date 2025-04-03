--  ========================================= SESI 1 ===================================================

--  # 1 
-- SELECT 
-- 	COUNT(DISTINCT product_category_name) as total_category
-- FROM products
-- WHERE product_category_name IS NOT NULL

-- ==============================================

-- # 2

-- SELECT
-- 	'seller' as category,
-- 	COUNT(DISTINCT seller_id) as total
-- FROM order_items
-- UNION
-- SELECT
-- 	'customer' as category,
-- 	COUNT(DISTINCT customer_unique_id) as total
-- FROM customers
	
-- ==============================================

-- # 3

-- SELECT
-- 	customer_city,
-- 	COUNT(DISTINCT customer_unique_id) as total_customer
-- FROM customers 
-- GROUP BY customer_city
-- ORDER BY total_customer DESC
-- LIMIT 10 

-- ==============================================

-- # 4

-- WITH customer_count AS(
-- 	SELECT
-- 		customer_city,
-- 		COUNT(DISTINCT customer_unique_id) as total_customer
-- 	FROM customers 
-- 	GROUP BY customer_city
-- 	ORDER BY total_customer DESC
-- )

-- SELECT
-- 	customer_city,
-- 	total_customer,
-- 	ROUND(total_customer / (SELECT SUM(total_customer) FROM customer_count) * 100, 2) as percentage_base_customer
-- FROM customer_count
-- GROUP BY customer_city, total_customer
-- ORDER BY total_customer DESC
-- LIMIT 10

-- ==============================================

-- # 5

-- SELECT
-- 	product_category_name,
-- 	COUNT(product_category_name) as total_unique_product
-- FROM products
-- GROUP BY product_category_name
-- ORDER BY total_unique_product DESC 
-- LIMIT 10

-- ==============================================

-- # 6

-- SELECT
-- 	'height_cm' as measured_variable,
-- 	MIN(product_height_cm),
-- 	CAST(PERCENTILE_DISC(0.25) WITHIN GROUP(ORDER BY product_height_cm) as int) as q1,
-- 	CAST(PERCENTILE_DISC(0.5) WITHIN GROUP(ORDER BY product_height_cm) as int) as q2,
-- 	CAST(PERCENTILE_DISC(0.75) WITHIN GROUP(ORDER BY product_height_cm) as int) as q3,
-- 	MAX(product_height_cm)
-- FROM products
-- UNION
-- SELECT
-- 	'length_cm' as measured_variable,
-- 	MIN(product_length_cm),
-- 	CAST(PERCENTILE_DISC(0.25) WITHIN GROUP(ORDER BY product_length_cm) as int) as q1,
-- 	CAST(PERCENTILE_DISC(0.5) WITHIN GROUP(ORDER BY product_length_cm) as int) as q2,
-- 	CAST(PERCENTILE_DISC(0.75) WITHIN GROUP(ORDER BY product_length_cm) as int) as q3,
-- 	MAX(product_length_cm)
-- FROM products
-- UNION
-- SELECT
-- 	'weight_cm' as measured_variable,
-- 	MIN(product_weight_g),
-- 	CAST(PERCENTILE_DISC(0.25) WITHIN GROUP(ORDER BY product_weight_g) as int) as q1,
-- 	CAST(PERCENTILE_DISC(0.5) WITHIN GROUP(ORDER BY product_weight_g) as int) as q2,
-- 	CAST(PERCENTILE_DISC(0.75) WITHIN GROUP(ORDER BY product_weight_g) as int) as q3,
-- 	MAX(product_weight_g)
-- FROM products
-- UNION
-- SELECT
-- 	'width_cm' as measured_variable,
-- 	MIN(product_width_cm),
-- 	CAST(PERCENTILE_DISC(0.25) WITHIN GROUP(ORDER BY product_width_cm) as int) as q1,
-- 	CAST(PERCENTILE_DISC(0.5) WITHIN GROUP(ORDER BY product_width_cm) as int) as q2,
-- 	CAST(PERCENTILE_DISC(0.75) WITHIN GROUP(ORDER BY product_width_cm) as int) as q3,
-- 	MAX(product_width_cm)
-- FROM products
-- ORDER BY measured_variable

-- ==============================================

-- # 7

WITH orders_converted_days AS (
SELECT
	order_id,
	customer_id,
	order_status,
	to_char(day, CAST(created_at as DATE), 'Day') as day_created
FROM orders
)

SELECT * FROM orders_converted_days

-- SELECT * FROM orders








