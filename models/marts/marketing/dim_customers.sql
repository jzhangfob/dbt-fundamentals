with customers as (

  select *
  from {{ ref('stg_jaffle_shop__customers') }}

),

orders as (

  select *
  from {{ ref('fct_orders') }}

),

customer_orders as (

  select customer_id,
  min(order_date) as first_order_date,
  max(order_date) as most_recent_order_date,
  count(distinct order_id) as number_of_orders,
  sum(amount) as lifetime_value
  from orders
  group by 1
),

final as (

  select a.customer_id,
  a.first_name,
  a.last_name,
  b.first_order_date,
  b.most_recent_order_date,
  coalesce(b.number_of_orders, 0) as number_of_orders,
  coalesce(b.lifetime_value, 0) as lifetime_value
  from customers a left join customer_orders b on a.customer_id = b.customer_id

)

select * from final 