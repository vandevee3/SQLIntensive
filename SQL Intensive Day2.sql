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

-- WITH orders_converted_days AS (
-- SELECT
-- 	order_id,
-- 	customer_id,
-- 	order_status,
-- 	CAST(order_purchase_timestamp as DATE) as date,
-- 	to_char(CAST(order_purchase_timestamp as DATE), 'Day') as day_created
-- FROM orders
-- )

-- SELECT
-- 	day_created as day_of_purchase,
-- 	COUNT(order_id) as total_purchase
-- FROM orders_converted_days
-- GROUP BY day_created
-- ORDER BY total_purchase DESC

-- ==============================================

-- # 8

-- SELECT
-- 	'order_canceled' as order_stages,
-- 	COUNT(order_id) as total
-- FROM orders
-- WHERE order_status = 'canceled'
-- UNION
-- SELECT
-- 	'order_approved' as order_stages,
-- 	COUNT(order_id) as total
-- FROM orders
-- WHERE order_status = 'canceled' AND order_approved_at IS NOT NULL 
-- UNION
-- SELECT
-- 	'order_delivered_carrier' as order_stages,
-- 	COUNT(order_id) as total
-- FROM orders
-- WHERE order_status = 'canceled' AND (order_approved_at, order_delivered_carrier_date) IS NOT NULL 
-- UNION 
-- SELECT
-- 	'order_delivered_carrier' as order_stages,
-- 	COUNT(order_id) as total
-- FROM orders
-- WHERE order_status = 'canceled' AND (order_approved_at, order_delivered_carrier_date, order_delivered_customer_date) IS NOT NULL 
-- ORDER BY total DESC

-- ==============================================

-- # 9

-- WITH payments_types AS (
-- 	SELECT 
-- 		py.payment_type,
-- 		COUNT(DISTINCT py.order_id) as total_order
-- 	FROM payments as py
-- 	JOIN orders as ord
-- 		ON py.order_id = ord.order_id
-- 	WHERE ord.order_status = 'canceled'
-- 	GROUP BY py.payment_type
-- 	ORDER BY total_order DESC
-- )

-- SELECT
-- 	payment_type,
-- 	total_order,
-- 	CAST(total_order as numeric) / CAST((SELECT SUM(total_order) FROM payments_types) as numeric) as prop_canceled_propotion
-- FROM payments_types
-- GROUP BY payment_type, total_order
-- ORDER BY total_order DESC

-- ==============================================

-- # 10

-- WITH named_category AS(
-- 	SELECT
-- 		prd.product_category_name as product_category,
-- 		prd.product_id,
-- 		oi.price,
-- 		DENSE_RANK() OVER(PARTITION BY prd.product_category_name ORDER BY oi.price DESC ) as price_rank
-- 	FROM order_items as oi
-- 	JOIN products as prd
-- 		ON oi.product_id = prd.product_id
-- 	WHERE prd.product_category_name != ''
-- ), unnamed_category AS (
-- 	SELECT
-- 		'other' as product_category,
-- 		prd.product_id,
-- 		oi.price,
-- 		RANK() OVER(ORDER BY oi.price DESC ) as price_rank
-- 	FROM order_items as oi
-- 	JOIN products as prd
-- 		ON oi.product_id = prd.product_id
-- 	WHERE prd.product_category_name = ''
-- )

-- SELECT * FROM named_category
-- WHERE price_rank = 3
-- UNION
-- SELECT DISTINCT * FROM unnamed_category
-- WHERE price_rank = 3
-- ORDER BY product_category

-- ==============================================

-- # 11

-- SELECT
-- 	'On Time' as order_delivered_status,
-- 	ROUND(AVG(CASE WHEN ord.order_id IS NOT NULL THEN rw.review_score END), 2) as ratarata_score
-- FROM reviews as rw
-- JOIN orders as ord
-- 	ON rw.order_id = REPLACE(CAST(ord.order_id as VARCHAR), '-', '')
-- WHERE order_delivered_customer_date <= order_estimated_delivery_date
-- UNION
-- SELECT
-- 	'Late' as order_delivered_status,
-- 	ROUND(AVG(CASE WHEN ord.order_id IS NOT NULL THEN rw.review_score END), 2) as ratarata_score
-- FROM reviews as rw
-- JOIN orders as ord
-- 	ON rw.order_id = REPLACE(CAST(ord.order_id as VARCHAR), '-', '')
-- WHERE order_delivered_customer_date > order_estimated_delivery_date
-- ORDER BY ratarata_score DESC

-- ==============================================

-- # 12

-- WITH calculated_days AS (
-- 	SELECT
-- 		EXTRACT(DAY FROM order_delivered_customer_date - order_purchase_timestamp) as days_purchased_to_delivered
-- 	FROM orders
-- 	WHERE order_status = 'delivered'
-- )

-- SELECT
-- 	days_purchased_to_delivered,
-- 	COUNT(days_purchased_to_delivered) as total
-- FROM calculated_days
-- GROUP BY days_purchased_to_delivered
-- ORDER BY total DESC

-- ==============================================

-- # 13

-- WITH customer_unique AS(
-- 	SELECT
-- 		cus.customer_unique_id,
-- 		ord.order_id,
-- 		ord.order_status,
-- 		py.payment_value * py.payment_sequential as revenue
-- 	FROM payments as py
-- 	JOIN orders as ord
-- 		ON py.order_id = ord.order_id
-- 	JOIN customers as cus
-- 		ON ord.customer_id = cus.customer_id
-- 	WHERE ord.order_status = 'delivered'
-- )

-- SELECT 
-- 	customer_unique_id,
-- 	SUM(revenue) as total_revenue,
-- 	COUNT(order_id) as total_order,
-- 	SUM(revenue) / COUNT(order_id) as avg_purchase_value
-- FROM customer_unique
-- GROUP BY customer_unique_id
-- ORDER BY avg_purchase_value DESC
-- LIMIT 10

-- ==============================================

-- # 14










