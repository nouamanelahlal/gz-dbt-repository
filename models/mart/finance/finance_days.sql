{{ config(materialized="table") }}

with orders as (
    select
        cast(date_date as date) as order_date,
        orders_id,
        products_id,
        quantity,
        purchase_price
    from {{ ref('int_sales_margin') }}
),

payments as (
    select
        order_date,
        count(distinct orders_id) as total_transactions,
        sum(purchase_price * quantity) as total_revenue
    from orders
    group by order_date
),

items as (
    select
        o.order_date,
        sum(o.purchase_price * o.quantity) as total_purchase_cost,
        sum(s.shipping_fee) as total_shipping_fees,
        sum(o.quantity) as total_quantity_sold
    from orders o
    left join {{ ref('stg_raw__ship') }} s using (orders_id)
    group by o.order_date
),

logistics as (
    select
        o.order_date,
        sum(s.logcost) as total_log_costs
    from orders o
    left join {{ ref('stg_raw__ship') }} s using (orders_id)
    group by o.order_date
),

final as (
    select
        p.order_date,
        p.total_transactions,
        p.total_revenue,
        round(p.total_revenue / nullif(p.total_transactions,0),2) as average_basket,
        i.total_purchase_cost,
        i.total_shipping_fees,
        l.total_log_costs,
        i.total_quantity_sold,
        (p.total_revenue - i.total_purchase_cost - i.total_shipping_fees - l.total_log_costs) as operational_margin
    from payments p
    left join items i on p.order_date = i.order_date
    left join logistics l on p.order_date = l.order_date
)

select * from final
order by order_date
