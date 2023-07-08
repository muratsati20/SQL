--1. How many customers are in each city? Your solution should include the city name and the number of customers sorted from highest to lowest.
	
	select city, count(customer_id) num_costumer
	from sale.customer
	group by city
	order by num_costumer desc;

--2. Find the total product quantity of the orders. Your solution should include order ids and quantity of products.
	select order_id, SUM(quantity) quantity_of_products
	from sale.order_item
	group by order_id;

--3. Find the first order date for each customer_id.
	select customer_id, MIN(order_date) min_order_date
	from sale.orders
	group by customer_id;

--4. Find the total amount of each order. Your solution should include order id and total amount sorted from highest to lowest.
	select order_id, sum(list_price) total_amount
	from sale.order_item 
	group by order_id
	order by total_amount desc;

--5. Find the order id that has the maximum average product price. Your solution should include only one row with the order id and average product price.
	select top 1 order_id, AVG(list_price) avg_product_price
	from sale.order_item
	group by order_id
	order by avg_product_price desc;
	
--6. Write a query that displays brand_id, product_id and list_price sorted first by brand_id (in ascending order), and then by list_price  (in descending order).
	select brand_id, product_id, list_price 
	from product.product
	order by brand_id asc, list_price desc;

--7. Write a query that displays brand_id, product_id and list_price, but this time sorted first by list_price (in descending order), and then by brand_id (in ascending order).
	select brand_id, product_id, list_price 
	from product.product
	order by list_price desc, brand_id asc;

--8. Compare the results of these two queries above. How are the results different when you switch the column you sort on first? (Explain it in your own words.)
	--In the first example we sorted first brand_id descending and the result shows that sorted brand id first works like group by
	--But the second example gives us just sorted list price than nothing

--9. Write a query to pull the first 10 rows and all columns from the product table that have a list_price greater than or equal to 3000.
	select top 10 *
	from product.product
	where list_price >= 3000;

--10. Write a query to pull the first 5 rows and all columns from the product table that have a list_price less than 3000.
	select top 5 *
	from product.product
	where list_price <= 3000;

--11. Find all customer last names that start with 'B' and end with 's'.
	select first_name, last_name
	from sale.customer
	where last_name like 'B%s';

--12. Use the customer table to find all information regarding customers whose address is Allen or Buffalo or Boston or Berkeley.
	select *
	from sale.customer
	where city in ('Allen','Buffalo','Boston','Berkeley')
