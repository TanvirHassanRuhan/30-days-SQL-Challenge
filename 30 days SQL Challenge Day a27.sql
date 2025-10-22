USE sql_challenge;
select * from customers;
select * from orders;
select * from products;
select * from order_items;

-- 1.Find each customer’s total lifetime value (sum of all orders) and average order value.
-- Return: customer_id, name, total_orders, lifetime_value, avg_order_value

select
c.customer_id ,
c.name as customers_name,
count(distinct o.order_id) as total_orders,
sum(o.total_amount) as lifetime_value,
round(sum(o.total_amount)/count(distinct o.order_id),2) as aov
from customers c 
join orders o on c.customer_id = o.customer_id
group by c.name,c.customer_id 
order by lifetime_value desc ;

-- 2.List the top 5 customers who spent the most overall.
-- Include: customer_id, name, total_spent, and their percentage share of total revenue.
select c.customer_id,c.name,
sum(p.price * oi.quantity) as total_spent, 
ROUND((SUM(p.price * oi.quantity) * 100.0) / (SELECT SUM(p.price * oi.quantity) 
FROM order_items oi 
JOIN products p ON oi.product_id = p.product_id),2) AS percent_share
from customers c
join orders o on c.customer_id = o.customer_id
join order_items oi on oi.order_id = o.order_id
join products p on p.product_id = oi.product_id
group by c.customer_id,c.name
order by  total_spent desc 
limit 5 
;

-- 3.Calculate the Average Order Value (AOV) for all orders.
-- Formula → total revenue ÷ total number of orders.
select * from orders;
SELECT 
ROUND(SUM(total_amount) / COUNT(order_id), 2) AS avg_order_value
FROM orders;

-- 4.Show each product category, its total revenue, and its percentage contribution to the overall revenue.
-- (Hint: Use SUM() + SUM() OVER() window)

select 
p.category,
round(sum(p.price * oi.quantity),2) as total_revenue,
ROUND(100 * SUM(oi.quantity * p.price) / SUM(SUM(oi.quantity * p.price)) OVER (), 2) AS percentage_contribution
from products p
join order_items oi on p.product_id = oi.product_id
group by p.category
order by total_revenue desc ;

-- 5.Find each country’s total revenue and its percentage contribution to total revenue.
-- (Hint: Use SUM(o.total_amount) + OVER())
select * from orders;

select 
c.country as country_name,
sum(total_amount) as total_revenue,
ROUND(100 * SUM(total_amount) / SUM(SUM(total_amount)) OVER (), 2) AS percentage_contribution
from customers c 
join orders o on c.customer_id = o.customer_id
group by c.country
order by total_revenue desc ;

select * from orders;
select * from order_items;
-- 6.For each month, calculate:total revenue,previous month’s revenue,month-over-month percentage growth (Hint: use LAG())
with monthly_revenue as(
select 
date_format(order_date,'%Y-%m') as months ,
round(sum(p.price * quantity),2) as total_revenue
from orders o 
join customers c on o.customer_id = c.customer_id
join order_items oi on oi.order_id = o.order_id
join products p on p.product_id = oi.product_id
group by date_format(order_date,'%Y-%m')
)
select 
months,
total_revenue,
LAG(total_revenue) over(order by months) as previous_month_revenue,
ROUND((total_revenue - LAG(total_revenue) OVER (ORDER BY months)) * 100.0 / 
          LAG(total_revenue) OVER (ORDER BY months), 2) AS growth_pct
 from monthly_revenue
 ;
 
-- 7.Rank customers by total spending within each country.Include: country, name, total_spent, rank_in_country
-- (Hint: Use RANK() with PARTITION BY)
select 
c.country as country_name,
c.name as customers_name,
round(sum(p.price * oi.quantity),2) as total_spent,
rank() over(partition by country order by sum(p.price * oi.quantity) desc) as rank_in_country
from orders o 
join customers c on o.customer_id = c.customer_id
join order_items oi on oi.order_id = o.order_id
join products p on p.product_id = oi.product_id
group by c.country,c.name;

-- 8.Segment customers based on their total spending (CLV):High if > 300,Medium if between 150–300,Low otherwise
-- Return: customer_id, clv, segment
with customer_value as (
select customer_id ,sum(total_amount) as clv 
from orders 
group by customer_id)
select *,
case 
when clv >300 then 'High'
when clv between 150 and 300 then 'Medium'
else 'Low'
end as segment 
from customer_value
;

-- 9.Find customers who haven’t ordered in the last 90 days.
-- Show: customer_id, last_purchase_date, days_inactive, and status (Active or Churned)

SELECT 
customer_id,
MAX(order_date) AS last_purchase,
DATEDIFF(CURDATE(), MAX(order_date)) AS days_inactive,
CASE 
WHEN DATEDIFF(CURDATE(), MAX(order_date)) > 90 THEN 'Churned'
ELSE 'Active'
END AS status
FROM orders
GROUP BY customer_id;

-- 10.Group customers by the month of their first purchase and count how many were active in each following month.
-- Return: cohort_month, order_month, active_customers.

WITH first_purchase AS (
SELECT 
customer_id,
MIN(DATE_FORMAT(order_date, '%Y-%m')) AS cohort_month
FROM orders
GROUP BY customer_id
)
SELECT 
f.cohort_month,
DATE_FORMAT(o.order_date, '%Y-%m') AS order_month,
COUNT(DISTINCT o.customer_id) AS active_customers
FROM first_purchase f
JOIN orders o ON f.customer_id = o.customer_id
GROUP BY f.cohort_month, DATE_FORMAT(o.order_date, '%Y-%m')
ORDER BY f.cohort_month, order_month;

