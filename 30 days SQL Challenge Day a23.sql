USE sql_challenge;
select * from customers;
select * from orders;
select * from products;
select * from order_items;

-- 1.Find the total revenue generated from each country.
select c.country,round(sum(p.price * oi.quantity),2) as total_revenue
from customers c 
join orders o on c.customer_id = o.customer_id
join order_items oi on  o.order_id = oi.order_id
join products p on p.product_id = oi.product_id
group by c.country
order by round(sum(p.price * oi.quantity),2) desc;

-- 2.Find the top 3 best-selling products in each category based on total quantity sold.
with cte as (
select p.product_name,p.category,sum(oi.quantity) as total_quantity,
rank() over(partition by p.category order by sum(oi.quantity) desc) as rn
from products p 
join order_items oi on p.product_id = oi.product_id
group by p.product_name, p.category)

select * from cte where rn<=3;

select * from customers;
-- 3.List all customers whose total spending exceeds $1000.
with cte2 as(
select c.name,round(sum(p.price * oi.quantity),2) as total_revenue
from customers c 
join orders o on c.customer_id = o.customer_id
join order_items oi on  o.order_id = oi.order_id
join products p on p.product_id = oi.product_id
group by c.name
order by round(sum(p.price * oi.quantity),2) desc)
select * from cte2 where  total_revenue >1000
;

-- 4.Show monthly revenue trends (total revenue per month).
select * from orders;
select 
EXTRACT(MONTH FROM order_date) AS months,
sum(total_amount) as total_revenue
from orders
group by EXTRACT(MONTH FROM order_date)
order by sum(total_amount) desc ;

-- 5.Find all products that were never ordered.
select p.product_name,count(oi.order_id) as no_of_order from products p 
left join order_items oi on p.product_id = oi.product_id
where oi.order_id is null
group by  p.product_name ;

select * from products;
select * from customers;
select * from orders;
select * from order_items;

-- 6.Find each customer’s first and last purchase date.
select 
c.name,
min(o.order_date) as first_purchase_date,
max(o.order_date) as last_purchase_date
from customers c 
join orders o on c.customer_id = o.customer_id
group by c.name;


-- 7.Find the average order value (AOV) per country.
SELECT 
c.country,
ROUND(AVG(o.total_amount), 2) AS avg_order_value
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.country
ORDER BY avg_order_value DESC;

-- 8.Find the top 5 customers who placed the most orders.
SELECT c.name,
COUNT(DISTINCT o.order_id) AS no_of_orders
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.name
ORDER BY no_of_orders DESC
LIMIT 5;

-- 9.Find the revenue and percentage contribution of each product category to total revenue.

WITH category_revenue AS (
SELECT p.category,
SUM(oi.quantity * p.price) AS category_total
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.category
)
SELECT 
category,
ROUND(category_total, 2) AS total_revenue,
ROUND(category_total * 100 / (SELECT SUM(category_total) FROM category_revenue), 2) AS percentage_share
FROM category_revenue
ORDER BY percentage_share DESC;

-- 10.Calculate cumulative (running) total of revenue month by month.

SELECT 
DATE_FORMAT(order_date, '%Y-%m') AS month,
SUM(total_amount) AS monthly_revenue,
SUM(SUM(total_amount)) OVER (ORDER BY DATE_FORMAT(order_date, '%Y-%m')) AS running_total
FROM orders
GROUP BY month
ORDER BY month;

