with 

source as (

    select * from {{ source('raw', 'sales') }}
      where orders_id is not null
      and pdt_id is not null

),

renamed as (

    select
        date_date,
        orders_id,
        pdt_id AS products_id,
        revenue,
        quantity,
    cast(orders_id as string) || '-' || cast(pdt_id as string) as sales_pk
    from source
    group by date_date, orders_id, products_id, revenue, quantity
)

select * from renamed
