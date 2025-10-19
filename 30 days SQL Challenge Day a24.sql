USE sql_challenge;
select * from customers;
select * from orders;
select * from products;
select * from order_items;

-- 1.Show total revenue per month and month-over-month growth percentage.
WITH cte2 AS (
SELECT 
DATE_FORMAT(order_date, '%Y-%m') AS months,
SUM(total_amount) AS revenue
FROM orders
GROUP BY DATE_FORMAT(order_date, '%Y-%m')
)
SELECT months,revenue,
LAG(revenue) OVER (ORDER BY months) AS previous_month_revenue,
ROUND(((revenue - LAG(revenue) OVER (ORDER BY months)) * 100.0)/ LAG(revenue) OVER (ORDER BY months),2) AS mon_growth_change
FROM cte2;

-- 2.Show total revenue per month, YoY growth percentage (compare same month with previous year).
WITH cte2 AS (
SELECT 
DATE_FORMAT(order_date, '%Y') AS years,
SUM(total_amount) AS revenue
FROM orders
GROUP BY DATE_FORMAT(order_date, '%Y')
)
SELECT years,revenue,
LAG(revenue) OVER (ORDER BY years) AS previous_years_revenue,
ROUND(((revenue - LAG(revenue) OVER (ORDER BY years)) * 100.0)/ LAG(revenue) OVER (ORDER BY years),2) AS yr_growth_change
FROM cte2;

-- 3.Find top 3 products in each category based on quantity sold and their percentage contribution to category sales.
WITH category_sales AS (
    SELECT 
        p.category,
        p.product_name,
        SUM(oi.quantity) AS total_quantity
    FROM order_items oi
    JOIN products p ON oi.product_id = p.product_id
    GROUP BY p.category, p.product_name
),
ranked_products AS (
    SELECT 
        category,
        product_name,
        total_quantity,
        DENSE_RANK() OVER (PARTITION BY category ORDER BY total_quantity DESC) AS rnk,
        total_quantity * 100.0 / SUM(total_quantity) OVER (PARTITION BY category) AS percentage_contribution
    FROM category_sales
)
SELECT 
    category,
    product_name,
    total_quantity,
    ROUND(percentage_contribution, 2) AS percentage_contribution
FROM ranked_products
WHERE rnk <= 3
ORDER BY category, total_quantity DESC;

-- 4.Find total spending per customer and their percentage contribution to total revenue.
select * from products;
select * from customers;
select * from orders;

select c.name,
sum(o.total_amount) as total_spend,
ROUND((SUM(o.total_amount) * 100.0) / (SELECT SUM(total_amount) FROM orders),2) AS percentage_contribution
 from customers c 
join orders o on c.customer_id = o.customer_id
group by c.name;

-- 5.Calculate cumulative revenue month by month (running total).
with running as(
select date_format(order_date,'%Y-%m') as months,
sum(total_amount) as revenue
from orders
group by date_format(order_date,'%Y-%m'))
select months,revenue,
sum(revenue) over( order by months) as running_total from running 
order by months
;

-- 6.Calculate 3-month rolling average of monthly revenue.
with running1 as(
select date_format(order_date,'%Y-%m') as months,
sum(total_amount) as revenue
from orders
group by date_format(order_date,'%Y-%m'))
select months,revenue,
avg(revenue) over( order by months rows between 2 preceding and current row) as rolling_avg from running1 
order by months
;

-- 7.Show AOV per customer and AOV per country.
select * from customers;
select * from orders;
-- AOV per customer 
select c.name as customer_name,
round(sum(o.total_amount)/count(order_id),2) as AOV
from customers c
join orders o on c.customer_id = o.customer_id
group by c.name
order by AOV DESC;

-- AOV per country.
select c.country as country_name,
round(sum(o.total_amount)/count(order_id),2) as AOV
from customers c
join orders o on c.customer_id = o.customer_id
group by c.country
order by AOV DESC;

-- 8. Top 5 Customers by Total Spending.Include their total spending, number of orders, and percentage contribution to overall revenue.

SELECT 
c.name AS customer_name,
SUM(o.total_amount) AS total_spending,
COUNT(DISTINCT o.order_id) AS no_of_orders,
ROUND((SUM(o.total_amount) * 100.0) / (SELECT SUM(total_amount) FROM orders),2) AS percentage_contribution
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.name
ORDER BY total_spending DESC
LIMIT 5;

-- 9.Find total revenue per product category and percentage share of total revenue.
WITH category_revenue AS (
SELECT 
p.category AS product_category,
SUM(p.price * oi.quantity) AS total_revenue
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY p.category
)
SELECT 
product_category,
ROUND(total_revenue, 2) AS total_revenue,
ROUND(total_revenue * 100.0 / SUM(total_revenue) OVER (), 2) AS percentage_share
FROM category_revenue
ORDER BY total_revenue DESC;

-- 10.Identify customers who spent > $1000 and placed more than 3 orders, include percentage of total revenue.

WITH customer_stats AS (
SELECT c.customer_id,c.name,
SUM(o.total_amount) AS total_spent,
COUNT(o.order_id) AS order_count
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name
)
SELECT customer_id,name,total_spent,order_count,
ROUND(total_spent * 100.0 / SUM(total_spent) OVER(), 2) AS percentage_of_total_revenue
FROM customer_stats
WHERE total_spent > 1000 AND order_count > 3
ORDER BY total_spent DESC;

