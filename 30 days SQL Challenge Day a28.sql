USE sql_challenge;
select * from customers;
select * from orders;
select * from products;
select * from order_items;

-- 1.Find each customer’s total spending and assign a rank based on total amount spent (highest first).
-- Show: customer_id, name, total_spent, rank_position.
select 
c.customer_id,c.name,
sum(o.total_amount) as total_spending,
rank() over(order by sum(o.total_amount) desc) as rnk
 from customers c 
join orders o on c.customer_id = o.customer_id
group by c.customer_id,c.name
order by total_spending desc;

-- 2.For every country, rank customers by their total spending using DENSE_RANK().
-- Show top 3 customers per country.
with dense_ranks as (
select
c.name,
c.country,
sum(o.total_amount) as total_spending,
dense_rank() over(partition by country order by sum(o.total_amount) desc) as rnk
 from customers c 
join orders o on c.customer_id = o.customer_id
group by c.country,c.name)
select * from dense_ranks where rnk <= 3
ORDER BY country, rnk, total_spending DESC;
;

-- 3.Rank each product within its category by total revenue (quantity × price).
-- Show: category, product_name, total_revenue, rank_in_category.
select 
p.product_name,
p.category,
sum(p.price * oi.quantity) as total_revenue,
rank() over(partition by p.category order by sum(p.price * oi.quantity) desc) as rnk
from products p 
join order_items oi  on p.product_id = oi.product_id
group by p.product_name,p.category;

-- 4.Using the ranking logic from Q3, show only the top 3 products per category.
with top_3 as (
select 
p.product_name,
p.category,
sum(p.price * oi.quantity) as total_revenue,
rank() over(partition by p.category order by sum(p.price * oi.quantity) desc) as rnk
from products p 
join order_items oi  on p.product_id = oi.product_id
group by p.product_name,p.category)
select * from top_3 where rnk<=3
;

-- 5.Use NTILE(4) to divide customers into 4 quartiles based on their total spending.
-- Label them as Q1 (highest spenders) to Q4 (lowest spenders).
select 
c.name as customers_name,
sum(total_amount) as total_spending ,
ntile(4) over(order by sum(o.total_amount) desc) as quartile
from customers c
join orders o on c.customer_id =o.customer_id
group by c.name 
;

-- 6.Calculate each product’s percentile rank and cumulative distribution (PERCENT_RANK() & CUME_DIST()) based on total revenue.
select 
p.product_name,
sum(p.price * oi.quantity) as total_revenue,
round(PERCENT_RANK() over(order by sum(p.price * oi.quantity) desc),2) as percentile_rank,
CUME_DIST() over (order by sum(p.price * oi.quantity)desc) as cumulative_distr
from products p 
join order_items oi on p.product_id = oi.product_id
group by p.product_name ;

-- 7.Show each category’s total revenue and its percentage share of overall revenue.
-- Include a rank column ordering categories by total revenue descending.
select p.category,
round(sum(p.price * oi.quantity),2) as total_revenue,
ROUND((SUM(p.price * oi.quantity) * 100.0) / (SELECT SUM(p.price * oi.quantity) 
FROM order_items oi 
JOIN products p ON oi.product_id = p.product_id),2) AS percent_share ,
rank() over(order by  sum(p.price * oi.quantity) desc) as rnk
from products p 
join order_items oi on p.product_id = oi.product_id
group by p.category;

select * from order_items;
select * from customers;
select * from products;
select * from orders;
-- 8.For every country, find the highest-spending customer (use RANK() or ROW_NUMBER()).
-- Show: country, customer_name, total_spent.
with highest as (
select 
c.country,
c.name as customer_name,
round(sum(p.price * oi.quantity),2) as total_spending ,
rank() over(partition by country order by sum(p.price * oi.quantity) desc ) as rn
from customers c
join orders o on c.customer_id = o.customer_id
join order_items oi on oi.order_id = o.order_id
join products p on p.product_id = oi.product_id
group by country,c.name 
order by country,c.name )
select * from highest where rn = 1
;

-- 9.Use PERCENT_RANK() to find orders in the top 10 % by total_amount.
with ranked_order as(
select 
order_id,
total_amount,
round(percent_rank() over(order by total_amount desc) ,2) as pct_rank
from orders)
select * from ranked_order 
where pct_rank >=0.9
order by total_amount desc;

-- 10.Assign both:a rank to each customer by total spending, and an NTILE(5) decile value (1 = top 20 %, 5 = bottom 20 %).
-- Show: customer_id, name, rank_position, decile.

-- Assign rank and NTILE(5) decile to each customer based on total spending

WITH customer_spending AS (
SELECT c.customer_id,c.name,
SUM(o.total_amount) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name
)
SELECT 
customer_id,
name,
RANK() OVER (ORDER BY total_spent DESC) AS rank_position,
NTILE(5) OVER (ORDER BY total_spent DESC) AS decile
FROM customer_spending
ORDER BY total_spent DESC;
