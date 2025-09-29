with joined as (
    select 
        s.orders_id,
        s.date_date,
        s.revenue,
        s.quantity,
        p.purchase_price,
        (s.quantity * p.purchase_price) AS  purchase_cost 
    from {{ ref('stg_raw__sales') }} AS s
    join {{ ref('stg_raw__product') }}  AS p
    using (products_id)
)

select
    *,
    ROUND((revenue - purchase_cost), 2) as margin
from joined
order by date_date desc