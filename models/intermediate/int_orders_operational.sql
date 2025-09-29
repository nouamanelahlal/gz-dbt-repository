SELECT
    orders_id,
    date_date,
    quantity
FROM {{ ref('int_orders_margin') }} AS m
JOIN {{ ref('stg_raw__ship') }} AS s
USING (orders_id)
