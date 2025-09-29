with joined as (
    select 
        s.*,
        p.purchase_price,
        ROUND((s.quantity * p.purchase_price), 2) AS  purchase_cost 
FROM  {{ ref('stg_raw__sales') }} AS s
INNER JOIN {{ ref('stg_raw__product') }} AS p

    using (products_id)
)

select
    *,
    ROUND((revenue - purchase_cost), 2) as margin
from joined