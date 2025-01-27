
with payments as (

    select *
    from {{ ref('stg_stripe__payments') }}

),

orders as (

    select *
    from {{ ref('stg_jaffle_shop__orders') }}

),

-- Find total amount per order 
order_payments as (

    select order_id,
    sum(case when status = 'success' then amount else 0 end) as amount 
    from payments 
    group by 1 

),

final as (

    select a.order_id,
    a.customer_id,
    a.order_date,
    coalesce(b.amount, 0) as amount
    from orders a left join order_payments b using (order_id)

)

select * from final 