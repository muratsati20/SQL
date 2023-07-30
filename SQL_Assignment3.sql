WITH ranked_product_orders AS (
    SELECT
		DISTINCT
        product_id
        ,MAX(discount) OVER (PARTITION BY product_id, discount) dis_per_product
        ,SUM(quantity) OVER (PARTITION BY product_id, discount) sum_quantity
    FROM
        sale.order_item
)
SELECT
    product_id,
    CASE 
        WHEN sum_quantity < LEAD(sum_quantity) OVER (ORDER BY product_id) THEN 'Positive'
        WHEN sum_quantity = LEAD(sum_quantity) OVER (ORDER BY product_id) THEN 'Neutral'
        ELSE 'Negative'
    END AS discount_effect
FROM
    ranked_product_orders;