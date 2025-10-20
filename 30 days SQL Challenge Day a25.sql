USE sql_challenge;
select * from customers;
select * from orders;
select * from products;
select * from order_items;

-- 1.Write a query to show each product category and its total sales amount (quantity × price).
select 
p.category  as product_category ,
round(sum(p.price * oi.quantity),2) as total_sales_amount 
from products p 
join order_items oi on p.product_id = oi.product_id
group by p.category ;


-- 2.Show the running total revenue ordered by order_date.
with running as (
select
order_date,
sum(total_amount) as revenue
from orders
group by order_date
 )
select
order_date,revenue,
sum(revenue) over(order by order_date) as running_total 
from running;

-- 3.Find each country’s total number of orders and how many of them are high-value orders (total_amount > 500).
-- Include the percentage of high-value orders for each country.

SELECT 
c.country,
COUNT(o.order_id) AS total_orders,
SUM(CASE WHEN o.total_amount > 500 THEN 1 ELSE 0 END) AS high_value_orders,
ROUND((SUM(CASE WHEN o.total_amount > 500 THEN 1 ELSE 0 END) * 100.0) / COUNT(o.order_id),2) AS percentage_high_value
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.country
ORDER BY percentage_high_value DESC;

-- 4.For each order date, calculate the 3-day rolling average of total revenue.
with rolling as (
select
order_date,
sum(total_amount) as revenue
from orders
group by order_date
 )
select
order_date,revenue,
round(avg(revenue) over(order by order_date rows between 2 preceding and current row),2) as rolling_avg 
from rolling;

-- 5.Calculate the month-over-month percentage growth in revenue for all orders.

WITH monthly_revenue AS (
SELECT 
DATE_FORMAT(order_date, '%Y-%m') AS month,
SUM(total_amount) AS revenue
FROM orders
GROUP BY DATE_FORMAT(order_date, '%Y-%m')
)
SELECT month,revenue,
LAG(revenue) OVER (ORDER BY month) AS prev_month_revenue,
ROUND(((revenue - LAG(revenue) OVER (ORDER BY month)) / LAG(revenue) OVER (ORDER BY month)) * 100,2) AS month_over_month_growth
FROM monthly_revenue;

-- 6.Show yearly revenue and year-over-year growth percentage.

WITH yearly_revenue AS (
SELECT 
year(order_date) AS years,
SUM(total_amount) AS revenue
FROM orders
GROUP BY year(order_date)
)
SELECT years,revenue,
LAG(revenue) OVER (ORDER BY years) AS prev_year_revenue,
ROUND(((revenue - LAG(revenue) OVER (ORDER BY years)) / LAG(revenue) OVER (ORDER BY years)) * 100,2) AS year_over_year_growth
FROM yearly_revenue;

-- 7.List all customers, their total spending, and their percentage contribution to total company revenue.
-- Sort by total spending (descending).

with percent as(
select c.name as customer_name,sum(oi.quantity * p.price) as total_spending from customers c 
join orders o on c.customer_id = o.customer_id
join order_items oi on oi.order_id = o.order_id
join products p on p.product_id = oi.product_id
group by c.name)
select
 customer_name,
    ROUND(total_spending, 2) AS total_spending,
    ROUND(total_spending * 100.0 / (SELECT SUM(total_spending) FROM percent), 2) AS percentage_contribution
from percent
group by customer_name
order by total_spending desc
;

-- 8. Find the top 3 products in each category based on quantity sold,
-- and show each product’s percentage contribution to its category’s total quantity.

WITH category_product_sales AS (
    SELECT 
        p.category AS product_category,
        p.product_name,
        SUM(oi.quantity) AS quantity_sold
    FROM products p
    JOIN order_items oi ON p.product_id = oi.product_id
    GROUP BY p.category, p.product_name
),
ranked AS (
    SELECT 
        product_category,
        product_name,
        quantity_sold,
        RANK() OVER (PARTITION BY product_category ORDER BY quantity_sold DESC) AS rnk,
        SUM(quantity_sold) OVER (PARTITION BY product_category) AS total_category_quantity
    FROM category_product_sales
)
SELECT 
    product_category,
    product_name,
    quantity_sold,
    ROUND(quantity_sold * 100.0 / total_category_quantity, 2) AS percentage_contribution
FROM ranked
WHERE rnk <= 3
ORDER BY product_category, quantity_sold DESC;

select * from customers;
-- 9. Within each country, rank customers by total spending and show their rank (1 = highest spender).
-- Return only top 3 customers per country.

WITH top_3 AS (
SELECT
c.name AS customer_name,
c.country,
SUM(oi.quantity * p.price) AS total_spending,
DENSE_RANK() OVER (PARTITION BY c.country ORDER BY SUM(oi.quantity * p.price) DESC) AS rnk
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON oi.order_id = o.order_id
JOIN products p ON p.product_id = oi.product_id
GROUP BY c.name, c.country
)
SELECT 
country,
customer_name,
ROUND(total_spending, 2) AS total_spending,rnk
FROM top_3
WHERE rnk <= 3
ORDER BY country, rnk;


-- 10.Classify each order into:‘High’ if total_amount > 1000,‘Medium’ if between 500–1000,‘Low’ otherwise
-- Then show the count of orders per segment and their percentage share of total orders.

SELECT 
CASE 
WHEN total_amount > 1000 THEN 'High'
WHEN total_amount BETWEEN 500 AND 1000 THEN 'Medium'
ELSE 'Low'
END AS order_segment,
COUNT(*) AS total_orders,
ROUND((COUNT(*) * 100.0 / (SELECT COUNT(*) FROM orders)), 2) AS percentage_share
FROM orders
GROUP BY order_segment
ORDER BY FIELD(order_segment, 'High', 'Medium', 'Low');
