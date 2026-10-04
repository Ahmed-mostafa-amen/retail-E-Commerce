
--create calendar2 to make changes and not to ruin the main table
CREATE TABLE calendar2 AS 
SELECT * FROM calendar
-----------------
--update the calendar
update calendar2
set day=extract(day from date),month=extract(month from date),
year=extract(year from date ),quarter =extract (quarter from date)
,weekday=to_char(date,'day'),week_number=extract(week from date)
---------------
--update the season
update calendar2
set season=case  WHEN EXTRACT(MONTH FROM date) IN (3, 4, 5) THEN 'Spring'
        WHEN EXTRACT(MONTH FROM date) IN (6, 7, 8) THEN 'Summer'
        WHEN EXTRACT(MONTH FROM date) IN (9, 10, 11) THEN 'Fall'
        ELSE 'Winter'
    END;
--------------
---check the order dates
select count(*) as total_orders,
count(case when shipped_date<order_date then 1 end) as shipped_before_ordered,
count (case when shipped_date>order_date +interval '30 days'then 1 end) as shipping_delay_over_30_days
from orders
-- found 501 shipped befored ordered  means i need to fix the date
------------------------------
create table orders2 as select*from orders
---------------
-- added a logical shipped date since this is random data
update orders2
set shipped_date = order_date +(floor(random()*5+1))::int
----------------------
--select * from orders2
select count(*) as total_orders,
 count (case when shipped_date<order_date then 1 end) as before_order,
 count  (case when shipped_date>order_date then 1 end) as after_order
 from orders2
--fixed the date
-----------------
select * from products
-----------
--too see how many products need to be reorderd
select count(case when units_in_stock>reorder_level then 1 end) as safe,
count(case when units_in_stock<=reorder_level then 1 end) as danger
from products
----------------------------
--to know which product need to be orderd
select product_id,product_name,units_in_stock,reorder_level,
(reorder_level - units_in_stock) AS units_needed
from products
WHERE units_in_stock <= reorder_level
-------------------------------------
-- check if there are inconsistent casing or spelling
select lower(trim(country)),count(*)
from customers
group by lower(trim(country))
having count(*)>1
---------------
create table customers2 as  select * from customers
-------------------
--fixed the spelling and inconsistent
update customers2
set country = INITCAP(trim(country))
-----------
--Top 10 customers by total spend 
SELECT customer_id,sum(total_amount) as total_spend
from orders2
group by customer_id
order by total_spend desc
limit 10
----------------------------------
--Average order value by country.
select ship_country,round(avg(total_amount),2) as avg_value
from orders2
group by ship_country
order by avg_value desc
----------------------------------------
--Customers who have never placed an order (LEFT JOIN anti-pattern)
select c.customer_id
from customers2 c
left join orders2 o on c.customer_id=o.customer_id
where o.customer_id is null
--------------------------------------
--Which payment_method is used most, and does average order value differ by payment method?
select payment_method,count(payment_method) as numb,round(avg(total_amount),2) as avg_order
from orders2
group by payment_method
------------------------------------------
--What % of orders fall into each order_status?
with percentage as (
select count(order_status)as total_order,count(case when order_status = 'pending' then 1  end)as pending,
count(case when order_status = 'shipped' then 1   end)as shipped,
count(case when order_status = 'processing' then 1  end)as prcessing,
count(case when order_status = 'delivered' then 1  end)as delivered
from orders2
)
select total_order,round((pending*100.0/total_order),2)as pending,round((shipped*100.0/total_order),2)as shipped ,
round((prcessing*100.0/total_order),2)as prcessing,
round((delivered*100.0/total_order),2) as delivered
from percentage
----------------------------
--Revenue by year and quarter — trending up, down, or flat?
with rev as (
select extract (year from order_date) as yearly,extract(quarter from order_date)as quarters,sum(total_amount) as total
from orders2
group by yearly,quarters
),
yearly_rev as (
select yearly,quarters,total as current_rev,lag(total) over(order by yearly,quarters) as prev_total,
lead(total) over(order by yearly,quarters) as next_total
from rev
)
select yearly,quarters,prev_total,current_rev,next_total,ROUND((current_rev - prev_total) * 100.0 / prev_total,2) as quarter_growth,
round((next_total-current_rev)*100.0/current_rev,2) as grow_percentge
from yearly_rev
order by yearly asc,quarters ASC
------------------------------
--What is the running total of revenue month-by-month over the entire timeline?
with rev as (
select  extract (year from order_date) as yearly,extract (month from order_date) as monthly,sum(total_amount) as month_total
from orders2
group by yearly,monthly),running_tot as (
select yearly,monthly,month_total,sum(month_total) over(order by yearly,monthly )as running_total
from rev)

select yearly,monthly,month_total,running_total ,round((month_total*100.0/running_total),2) as perc
from running_tot
-------------------------------------
--calculate a 3-month rolling average of revenue to smooth out seasonal spikes and see the true baseline trend?
with rev as (
select  extract (year from order_date) as yearly,extract (month from order_date) as monthly,round(avg(total_amount),2) as month_total
from orders2
group by yearly,monthly)
select yearly,monthly,round(month_total,2) as month_total,
round(avg(month_total) over(order by yearly,monthly rows between 2 preceding and current row),2)as rolling_month
from rev
-----------------------
--most ordered product
select p.product_name,count(distinct o.order_id) as order_counts
from orders2 o
join products p
on o.order_id=p.product_id
group by p.product_name

