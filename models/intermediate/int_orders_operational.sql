SELECT
    orders_id,
    date_date,
    ROUND(((margin + shipping_fee) - (logcost - ship_cost)),2) AS operational_margin,
    quantity
FROM sharp-effort-470110-s7.dbt_nouamane.int_orders_margin AS m
JOIN sharp-effort-470110-s7.dbt_nouamane.stg_raw__ship AS s
USING (orders_id)
