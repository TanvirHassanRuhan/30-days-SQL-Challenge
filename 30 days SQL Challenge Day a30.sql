USE sql_challenge;
select * from customers;
select * from orders;
select * from products;
select * from order_items;

-- 1.Show each customer’s total spending, rank them by total spending (highest first), and assign an NTILE(5) decile value.
-- Columns: customer_id, name, total_spent, rank_position, decile
select 
c.customer_id,
c.name as customers_name,
sum(p.price * oi.quantity) as total_spent,
rank() over(order by sum(p.price * oi.quantity) desc) as rnk,
ntile(5) over(order by sum(p.price * oi.quantity)desc) as spending_decile
from customers c
join orders o on c.customer_id = o.customer_id
join order_items oi on o.order_id = oi.order_id
join products p on oi.product_id = p.product_id 
group by c.customer_id,c.name ;

-- 2.Find the top 3 products in each category by total revenue.Include each product’s percentage contribution to its category’s total revenue.
-- Hint: Use RANK() + SUM() OVER(PARTITION BY category).
with category_revenue as (
select 
p.product_name,
p.category,
sum(p.price * oi.quantity) as total_revenue,
rank() over(partition by p.category order by sum(p.price * oi.quantity) desc) as rnk,
SUM(sum(p.price * oi.quantity)) OVER(PARTITION BY category) as category_total
from products p 
join order_items oi on p.product_id = oi.product_id
group by p.product_name,p.category)
SELECT 
    category,
    product_name,
    ROUND(total_revenue, 2) AS total_revenue,
    ROUND((total_revenue * 100.0 / category_total), 2) AS pct_contribution,
    rnk
FROM category_revenue
WHERE rnk <= 3
ORDER BY category, total_revenue DESC;

-- 3.For each month, calculate total revenue and month-over-month growth percentage.
-- Hint: Use LAG() and window-based division.
with growth as (
select 
date_format(o.order_date,'%Y-%m') as months,
round(sum(p.price * oi.quantity),2) as total_revenue
from customers c
join orders o on c.customer_id = o.customer_id
join order_items oi on o.order_id = oi.order_id
join products p on oi.product_id = p.product_id
group by  date_format(o.order_date,'%Y-%m'))
select *,
round(LAG(total_revenue) over(order by months),2) as prev_revenue,
ROUND(((total_revenue - LAG(total_revenue) OVER (ORDER BY months)) / LAG(total_revenue) OVER (ORDER BY months) ) * 100, 2) AS mom_growth_percentage
from growth;

-- 4.For each country, calculate:Total revenue,Total number of orders % of global revenue contribution
-- Order the result by total revenue (descending).
with global_revenue as(
select
c.country,
round(sum(p.price * oi.quantity),2) as total_revenue,
sum(oi.quantity) total_no_orders
from customers c
join orders o on c.customer_id = o.customer_id
join order_items oi on o.order_id = oi.order_id
join products p on oi.product_id = p.product_id
group by c.country)
select *,
ROUND(100 * total_revenue / SUM(total_revenue) OVER (), 2) AS pct_contribution
from global_revenue
ORDER BY total_revenue DESC
;

-- 5.Segment orders as: “High” if total_amount > 500,“Medium” if 250-500,“Low” otherwise,Show count and percentage of each segment.
select 
case 
when total_amount > 500 then 'High Value'
when total_amount between 250 and 500 then 'Medium Value'
Else 'Low Value'
END AS segment,
count(*) as total_orders,
round(count(*) *100/(select count(*) from orders),2) as percent_share
from orders
 group by segment;
 
 -- 6.Find customers who placed more than 5 orders and spent above the average spending.
-- Label them as ‘Loyal’ customers.Columns: customer_id, name, total_spent, order_count, status
WITH loyalty AS (
SELECT customer_id,
SUM(total_amount) AS total_spent,
COUNT(order_id) AS order_count
FROM orders
GROUP BY customer_id
)
SELECT c.customer_id,c.name,l.total_spent,l.order_count,
CASE 
WHEN l.order_count > 5 AND l.total_spent > (SELECT AVG(total_spent) FROM loyalty)
THEN 'Loyal'
ELSE 'Regular'
END AS status
FROM loyalty l
JOIN customers c ON l.customer_id = c.customer_id
WHERE l.order_count > 5 
AND l.total_spent > (SELECT AVG(total_spent) FROM loyalty);
  
-- 7.For each year, show total revenue and YoY growth %.
-- Hint: Use EXTRACT(YEAR FROM order_date) and LAG()
with groths as (
select 
EXTRACT(YEAR FROM order_date) as years,
round(sum(p.price * oi.quantity),2) as total_revenue
from customers c
join orders o on c.customer_id = o.customer_id
join order_items oi on o.order_id = oi.order_id
join products p on oi.product_id = p.product_id
group by EXTRACT(YEAR FROM order_date))
select *,
lag(total_revenue) over(order by years) as prev_year_revenue,
ROUND(((total_revenue - LAG(total_revenue) OVER (ORDER BY years)) / LAG(total_revenue) OVER (ORDER BY years) ) * 100, 2) AS yoy_growth_percentage
from groths
;

-- 8.For each product category, calculate:Total revenue,Number of distinct products sold,Average revenue per product
-- Each category’s % contribution to total company revenue.

WITH category_summary AS (
SELECT
p.category AS product_category,
round(SUM(p.price * oi.quantity),2) AS total_revenue,
COUNT(DISTINCT p.product_id) AS distinct_products,
ROUND(SUM(p.price * oi.quantity) / COUNT(DISTINCT p.product_id), 2) AS avg_revenue_per_product
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY p.category
)
SELECT*,
ROUND(100 * total_revenue / SUM(total_revenue) OVER (), 2) AS percent_contribution
FROM category_summary
ORDER BY total_revenue DESC;

-- 9.Group customers by their join month and calculate:Number of customers joined that month.Their total revenue contribution.
-- Hint: DATE_FORMAT(join_date, '%Y-%m')
select 
DATE_FORMAT(join_date, '%Y-%m') as months ,
count(c.customer_id) no_of_customers,
round(sum(p.price * oi.quantity),2) as total_revenue
from customers c
left join orders o on c.customer_id = o.customer_id
left join order_items oi on o.order_id = oi.order_id
left join products p on oi.product_id = p.product_id
group by DATE_FORMAT(join_date, '%Y-%m')
order by DATE_FORMAT(join_date, '%Y-%m');


-- 10.For each customer, calculate:Total lifetime revenue (sum of orders),Average order value (AOV)
-- % contribution to total company revenue.Then rank them by CLV.

WITH customer_clv AS (
SELECT c.customer_id,c.name,
SUM(o.total_amount) AS total_revenue,
round(AVG(o.total_amount),2) AS avg_order_value
FROM customers c 
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name
),
total_company_revenue AS (
SELECT SUM(total_revenue) AS company_revenue
FROM customer_clv
)
SELECT 
cc.customer_id,
cc.name,
cc.total_revenue,
cc.avg_order_value,
ROUND(cc.total_revenue / tcr.company_revenue * 100, 2) AS pct_of_total_revenue,
RANK() OVER (ORDER BY cc.total_revenue DESC) AS clv_rank
FROM customer_clv cc
CROSS JOIN total_company_revenue tcr
ORDER BY cc.total_revenue DESC;
