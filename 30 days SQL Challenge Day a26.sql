USE sql_challenge;
select * from customers;
select * from orders;
select * from products;
select * from order_items;

-- 1.List each product category, its total revenue, and the rank of that category based on revenue (highest = 1).
-- Use: SUM(), RANK() OVER()
select
p.category,
round(sum(p.price * oi.quantity),2) as total_revenue,
rank() over( order by sum(p.price * oi.quantity) desc) as rnk 
from products p 
join order_items oi on p.product_id = oi.product_id
group by p.category
order by total_revenue desc;

-- 2.Show the top 3 products in each category based on total quantity sold.
--  Use: RANK() OVER(PARTITION BY category ORDER BY SUM(quantity) DESC)
with ranked as (
select p.product_name, p.category,
sum(oi.quantity) as total_sold,
RANK() OVER(PARTITION BY category ORDER BY SUM(quantity) DESC) as rnk
from products p 
join order_items oi on p.product_id = oi.product_id
group by p.category , p.product_name)
select * from ranked where rnk<=3
;

-- 3.Find customers whose average order amount is greater than the overall average of all orders.

WITH average AS (
SELECT 
c.name AS customer_name,
ROUND(AVG(o.total_amount), 2) AS avg_order_amount
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.name
)
SELECT *
FROM average
WHERE avg_order_amount > (SELECT AVG(total_amount) FROM orders)
ORDER BY avg_order_amount DESC;

-- 4.List all products whose price is higher than their category’s average price.(correlated subquery)
select p1.product_name, p1.price 
from products p1
where price >(select avg(p2.price) from products p2
where p1.category = p2.category
);

select * from orders;

-- 5.Calculate each month’s total revenue and the cumulative (running) total revenue over time. Use: SUM() OVER(ORDER BY month)
select 
date_format( order_date,'%Y-%m')  as months ,
sum(total_amount) as total_revenue,
sum(sum(total_amount)) over(order by DATE_FORMAT(order_date, '%Y-%m')) as running_total
from orders
group by date_format( order_date,'%Y-%m');

-- 6.For every month, find its total revenue and its percentage contribution to total revenue.
--  Use: SUM() OVER() window with division
select 
date_format( order_date,'%Y-%m')  as months ,
sum(total_amount) as total_revenue,
ROUND(SUM(total_amount) * 100.0 / SUM(SUM(total_amount)) OVER (),2) AS percent_of_total
from orders
group by date_format( order_date,'%Y-%m');

-- 7.Classify each customer as:High Value: spent > 200,Medium: 100–200 Low: < 100
-- Show the count and percentage of customers in each segment. Use: CASE WHEN, aggregation, subquery for total
select 
case 
when total_amount >200 then 'High Value'
when total_amount between 100 and 200 then 'Medium Value'
else 'Low Value' 
end as segment,
count(*) as total_orders ,
round(count(*) * 100 /(select count(*) from orders),2) as percent_share
from orders 
group by segment;


-- 8.Compute revenue per month and the MoM growth % compared to the previous month.
 -- Use: LAG() + arithmetic difference

WITH monthly_revenue AS (
SELECT 
DATE_FORMAT(order_date, '%Y-%m') AS month,
SUM(total_amount) AS revenue
FROM orders
GROUP BY DATE_FORMAT(order_date, '%Y-%m')
)
SELECT month,revenue,
LAG(revenue) OVER (ORDER BY month) AS prev_month,
ROUND((revenue - LAG(revenue) OVER (ORDER BY month)) * 100.0 / LAG(revenue) OVER (ORDER BY month), 2) AS mom_growth
FROM monthly_revenue;

-- 9.Find the top 5 countries with the highest total revenue and their percentage share of total revenue.
--  Use: JOIN, GROUP BY, ORDER BY, LIMIT 5

SELECT 
c.country AS country_name,
round(SUM(p.price * oi.quantity),2) AS total_revenue,
ROUND(SUM(p.price * oi.quantity) * 100.0 / (SELECT SUM(p2.price * oi2.quantity)
FROM customers c2
JOIN orders o2 ON c2.customer_id = o2.customer_id
JOIN order_items oi2 ON oi2.order_id = o2.order_id
JOIN products p2 ON p2.product_id = oi2.product_id), 2) AS percentage_share
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON oi.order_id = o.order_id
JOIN products p ON p.product_id = oi.product_id
GROUP BY c.country
ORDER BY total_revenue DESC
LIMIT 5;


-- 10.High-Value Orders per Country For each country, calculate:total orders ,number of high-value orders (> 200),
-- percentage of high-value orders  Use: conditional aggregation + percentage formula
SELECT 
c.country,
COUNT(o.order_id) AS total_orders,
SUM(CASE WHEN o.total_amount > 200 THEN 1 ELSE 0 END) AS high_value_orders,
ROUND(SUM(CASE WHEN o.total_amount > 200 THEN 1 ELSE 0 END) * 100.0 / COUNT(o.order_id),2) AS high_value_percentage
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.country
ORDER BY high_value_percentage DESC;

