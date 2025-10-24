USE sql_challenge;
select * from customers;
select * from orders;
select * from products;
select * from order_items;

-- 1.Find each customer’s total spending and their percent rank compared to others.
-- Show: customer_id, total_spent, percent_rank.
select 
c.customer_id,
sum(o.total_amount) as total_spending,
round(percent_rank() over(order by sum(o.total_amount)desc),2) as percent_ranks
from customers c 
join orders o on c.customer_id = o.customer_id
group by c.customer_id;

-- 2.Using PERCENT_RANK(), list only those customers whose spending is in the top 10%.
-- Show: customer_id, name, total_spent, pct_rank.
with ranked as (
select 
c.customer_id,
c.name as customers_name,
sum(o.total_amount) as total_spent, 
round(PERCENT_RANK() over(order by sum(o.total_amount)desc),2) as pct_rank
from customers c 
join orders o on c.customer_id = o.customer_id
group by c.customer_id,c.name)

select * from ranked where pct_rank >= 0.9 ;

-- 3.Use CUME_DIST() to calculate the cumulative distribution of customer spending.
-- Show: customer_id, total_spent, cume_dist.

select 
c.customer_id,
sum(o.total_amount) as total_spending,
round(cume_dist() over(order by sum(o.total_amount)desc),2) as cume_dists
from customers c 
join orders o on c.customer_id = o.customer_id
group by c.customer_id
order by total_spending desc;

-- 4.Divide all customers into 5 deciles (NTILE(5)) based on total spending.
-- Show: customer_id, total_spent, spending_decile.

select 
c.customer_id,
sum(o.total_amount) as total_spending,
ntile(5) over(order by sum(o.total_amount)desc) as spending_decile
from customers c 
join orders o on c.customer_id = o.customer_id
group by c.customer_id
order by total_spending desc;

-- 5.Using NTILE(5), return only customers in the top 20% spending group.
-- Show: customer_id, name, total_spent, decile.
with top_20 as (
select 
c.customer_id,
c.name,
sum(o.total_amount) as total_spending,
ntile(5) over(order by sum(o.total_amount)desc) as spending_decile
from customers c 
join orders o on c.customer_id = o.customer_id
group by c.customer_id,c.name
order by total_spending desc)
select * from top_20 
WHERE spending_decile = 1
ORDER BY total_spending DESC;

-- 6.For each product, calculate its total revenue and assign a percent rank based on performance within its category.
-- Show: category, product_name, total_revenue, pct_rank.
select 
p.product_name,
p.category as product_category,
sum(p.price * oi.quantity) as total_revenue,
round(percent_rank() over(partition by p.category order by sum(p.price * oi.quantity) desc),2) as pct_rnk 

from products p 
join order_items oi on p.product_id =oi.product_id
group by p.product_name,p.category;

-- 7.For all products, compute their cumulative sales distribution (CUME_DIST()).
-- Show: product_id, product_name, category, cum_dist.
select
    p.product_id,
    p.product_name,
    p.category,
    cume_dist() over(order by sum(p.price * oi.quantity) desc) as cum_dist
from products p
join order_items oi on p.product_id = oi.product_id
group by p.product_id, p.product_name, p.category
order by cum_dist desc;

-- 8.For each month, calculate total revenue and divide it into quartiles (NTILE(4)).
-- Show: month, total_revenue, revenue_quartile.
select 
date_format(o.order_date,'%Y-%m') as months,
round(sum(p.price * oi.quantity),2) as total_revenue,
ntile(4) over(order by sum(p.price * oi.quantity)desc) as  revenue_quartile
from orders o
join order_items oi on o.order_id = oi.order_id
join products p on oi.product_id = p.product_id
group by date_format(o.order_date,'%Y-%m')
order by months desc;

-- 9.Using PERCENT_RANK(), find products in the bottom 10% by total revenue.
-- Show: product_name, category, total_revenue, pct_rank.
with buttom as(
select 
p.product_name,
p.category,
sum(p.price * oi.quantity) as total_revenue,
round(PERCENT_RANK() over(order by sum(p.price * oi.quantity)asc),2) as pct_rank
from products p 
join order_items oi on p.product_id = oi.product_id
group by p.product_name,p.category)
select * from buttom where pct_rank <=0.1
order by total_revenue asc
;

-- 10.Combined Ranking + Decile Assign both:a rank to each customer by total spending (RANK()), and
-- a decile (NTILE(10)) to show percentile segmentation.Show: customer_id, name, rank_position, decile.

select
    c.customer_id,
    c.name as customer_name,
    rank() over(order by sum(o.total_amount) desc) as rank_position,
    ntile(10) over(order by sum(o.total_amount) desc) as decile
from customers c
join orders o on c.customer_id = o.customer_id
group by c.customer_id, c.name
order by rank_position;
