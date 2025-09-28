with joined as (
    select 
        s.*,
        p.purchase_price,
        ROUND((s.quantity * p.purchase_price), 2) AS  purchase_cost 
    from `sharp-effort-470110-s7.dbt_nouamane.stg_raw__sales` s
    join `sharp-effort-470110-s7.dbt_nouamane.stg_raw__product` p
    using (products_id)
)

select
    *,
    ROUND((revenue - purchase_cost), 2) as margin
from joined