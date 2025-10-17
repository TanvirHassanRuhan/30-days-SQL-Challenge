USE sql_challenge;
select * from customers;
select * from orders;
select * from products;
select * from order_items;

-- 1.Show each customer's name along with the number of orders they’ve made. Sort the result by number of orders (descending).
select c.name,count(o.order_id)  as no_of_oder from customers c 
join orders o on c.customer_id = o.customer_id
group by c.name 
order by count(o.order_id) desc;

-- 2.Display each product name, category, and total revenue generated (price * quantity).Sort by revenue (highest first).
SELECT p.product_name,p.category,SUM(p.price * oi.quantity) AS total_revenue
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY p.product_name, p.category
ORDER BY total_revenue DESC;

-- 3.Find the total purchase amount per country. Hint: Join customers, orders, and order_items.

select c.country,sum(o.total_amount) as total_purchase_amount_per_country from customers c
join orders o on c.customer_id = o.customer_id
join order_items oi  on o.order_id = oi.order_id
group by c.country;

-- 4.List the top 5 customers who spent the most overall.Include their total amount spent.

SELECT c.customer_id,c.name AS customer_name,
SUM(oi.quantity * p.price) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
GROUP BY c.customer_id, c.name
ORDER BY total_spent DESC
LIMIT 5;

-- 5.For each product category, find:i)total number of products,ii)average product price iii)maximum price
select * from products;
select 
category,
count(product_id) as total_no_of_products,
round(avg(price),2) as  avg_prd_price,
max(price) as  max_price
from products 
group by category;

select * from products;
select * from order_items;
select * from orders;
-- 6.Show total revenue generated per month (use EXTRACT(MONTH FROM order_date) or MONTH(order_date)).Sort by month ascending.
select 
MONTH(order_date) as months,
round(sum(p.price * oi.quantity),2) as total_revenue
from orders o
join order_items oi on oi.order_id = o.order_id
join products p on p.product_id= oi.product_id
group by MONTH(order_date);

-- 7.Find the product that has been ordered the highest number of times (sum of quantities).
select p.product_name,sum(oi.quantity) as times_of_orders from products p 
join order_items oi on p.product_id = oi.product_id
group by p.product_name 
order by sum(oi.quantity) desc 
limit 1 ;

-- 8.List all customers who never placed any order. 
SELECT c.name FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;


-- 9.For each product category, show the product that sold the most units.
-- (Hint: Use RANK() or ROW_NUMBER() with PARTITION BY category ORDER BY SUM(quantity)).
WITH most AS (
SELECT p.category,p.product_name,
SUM(oi.quantity) AS sold_unit,
ROW_NUMBER() OVER (PARTITION BY p.category ORDER BY SUM(oi.quantity) DESC) AS rn
FROM products p JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY p.category, p.product_name
)
SELECT category, product_name, sold_unit
FROM most
WHERE rn = 1;

-- 10.Find all orders whose total_amount is greater than the average total_amount of all orders Return order_id, customer_id, total_amount.

SELECT order_id,customer_id,total_amount
FROM orders
WHERE total_amount > (SELECT AVG(total_amount) FROM orders);



