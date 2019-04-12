Use  sakila;
-- select  table--
select * from actor;
-- (1A) Display the first and last names of all actors from the table actor
select  first_name , last_name from actor;

-- (1B) Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name
select upper(Concat(first_name,last_name)) as Actor_Name from actor ;

-- (2A) find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe."
select actor_id,first_name,last_name from actor where first_name='joe';

-- (2B) Find all actors whose last name contain the letters GEN
 select * from actor where last_name like '%GEN%';
 
-- (2C) Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order:
select actor_id,last_name,first_name,last_update from actor where last_name like '%LI%' order by last_name and first_name;

-- (2D) Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:
select country_id ,country from country where country IN ('Afghanistan', 'Bangladesh','China');

-- (3A) create a column in the table actor named description and use the data type BLOB
Alter table  actor add column description blob ;

-- (3B) Delete the description column
Alter table actor drop column  description;

-- (4A)  List the last names of actors, as well as how many actors have that last name
select last_name,count(last_name) as 'how_many' from actor group by last_name ;

-- 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors.
select last_name,count(last_name) AS 'how_many' from actor group by last_name having count(last_name) >= 2;

-- 4c. The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS. Write a query to fix the record.
select first_name from actor where first_name='GROUCHO' and last_name='WILLIAMS';
Update  actor set first_name='HARPO' , last_name='WILLIAMS' where first_name='GROUCHO' and last_name='WILLIAMS';

-- 4d. Perhaps we were too hasty in changing GROUCHO to HARPO. 
-- It turns out that GROUCHO was the correct name after all! In a single query, 
-- if the first name of the actor is currently HARPO, change it to GROUCHO.
select first_name from actor where first_name='Harpo' and last_name='WILLIAMS';
Update  actor set first_name='GROUCHO' , last_name='WILLIAMS' where first_name='HARPO' and last_name='WILLIAMS';

-- 5a. You cannot locate the schema of the address table. Which query would you use to re-create it?

desc address;


-- 6a. Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address:

select s.first_name , s.last_name ,a.address,a.address2   from staff  as s  
inner join address a ON  a.address_id = s.address_id;

/*6b.  Use JOIN to display the total amount rung up by each 
staff member in August of 2005. Use tables staff and payment.*/	

select s.staff_id,sum(p.amount) as Total_Amount from payment p  
inner join staff s ON p.staff_id=s.staff_id 
where payment_date between'2005-08-01' and '2005-08-31' 
group by staff_id ;

-- 6d. How many copies of the film Hunchback Impossible exist in the inventory system?
select count(i.film_id) as How_many_copies from inventory i inner join film f on i.film_id=f.film_id where f.title="Hunchback Impossible"; 

/*6e. Using the tables payment and customer and the JOIN command, 
list the total paid by each customer. List the customers alphabetically by last name:*/

select c.first_name,c.last_name,sum(p.amount) as Total_Amount from payment p  
inner join customer c ON p.customer_id=c.customer_id group by c.customer_id
order by c.last_name asc ;

/*7a. The music of Queen and Kris Kristofferson have seen an unlikely 
resurgence. As an unintended consequence, films starting with the 
letters K and Q have also soared in popularity. Use subqueries to display 
the titles of movies starting with the letters K and Q whose language is English.*/
select title from film   where (title like'K%' or title like 'Q%') 
and language_id in (select language_id  from language where name="English");

-- 7b. Use subqueries to display all actors who appear in the film Alone Trip.

 select first_name , last_name from actor where  actor_id in (select actor_id from film_actor 
  where film_id in (select film_id from film where  title="Alone Trip"));
  
/* 7c. You want to run an email marketing campaign in Canada, 
for which you will need the names and email addresses of all Canadian customers.
 Use joins to retrieve this information.  */
 
 select c.first_name ,c.last_name from customer c inner join address  a on a.address_id=c.address_id 
 inner join city ci on ci.city_id =a.city_id 
 inner join country ct  on ct.country_id =ci.country_id where ct.country="canada";
 
 /*7d. Sales have been lagging among young families, and 
 you wish to target all family movies for a promotion. 
 Identify all movies categorized as family films.*/
 
 select f.title  from film f inner join film_category fc on f.film_id=fc.film_id 
 inner join category c on fc.category_id =c.category_id where c.name ="Family";
 
 -- 7e. Display the most frequently rented movies in descending order.
 
 select f.title, count(r.rental_id) as countof_movies from film f inner join inventory i  on f.film_id = i.film_id 
 inner join rental r on r.inventory_id = i.inventory_id group by f.title order by countof_movies desc;
 
 -- 7f. Write a query to display how much business, in dollars, each store brought in.
 
 select st.store_id ,sum(p.amount) as '$amount' from payment p inner join staff s on s.staff_id=p.staff_id 
 inner join store st on st.store_id =s.store_id group by st.store_id;
 
 -- 7g. Write a query to display for each store its store ID, city, and country.
 
 select s.store_id , c.city,ct.country from store s inner join address a on a.address_id =s.address_id 
 inner join city c on c.city_id =a.city_id inner join country ct on ct.country_id =c.country_id;
 
/*7h. List the top five genres in gross revenue in descending order. (Hint: you may need to 
 use the following tables: category, film_category, inventory, payment, and rental.)*/
 select  c.name, sum(p.amount) as amounts from category c inner join film_category fc on  c.category_id = fc.category_id
 inner join inventory i on i.film_id =fc.film_id  inner join rental r on r.inventory_id =i.inventory_id 
 inner join payment p on p.rental_id=r.rental_id group by c.name order by amounts desc Limit 5 ;
 
 /*8a. In your new role as an executive, you would like to have an easy way of
 viewing the Top five genres by gross revenue.
 Use the solution from the problem above to create a view. 
 If you haven't solved 7h, you can substitute another query to create a view.*/
 
 create view Top_Revenue as 
 select  c.name, sum(p.amount) as amounts from category c inner join film_category fc on  c.category_id = fc.category_id
 inner join inventory i on i.film_id =fc.film_id  inner join rental r on r.inventory_id =i.inventory_id 
 inner join payment p on p.rental_id=r.rental_id group by c.name order by amounts desc Limit 5;
 
 -- 8b. How would you display the view that you created in 8a?
 
 select * from Top_Revenue;
 
 -- 8c. You find that you no longer need the view top_five_genres. Write a query to delete it.
 drop view Top_Revenue;
 
 
  
 
  
 

 
 
 
 
 
 
 
 
 
 













