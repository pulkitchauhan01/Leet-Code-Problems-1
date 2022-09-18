Leetcode Problems 1

Type: Where and Subquery

1. Customers Who Never Order

SELECT 
    name AS Customers
FROM customers
WHERE id NOT IN (
    SELECT 
        customerid
    FROM orders
);


Type: Delete and Subquery

1. Delete Duplicate Emails

DELETE FROM person WHERE id NOT IN(
    SELECT * FROM(
        SELECT MIN(id) FROM person GROUP BY email
    )  AS p

);



Type: Case When

1.

SELECT 
    employee_id, 
    CASE
        WHEN employee_id % 2 = 0 OR name LIKE 'M%' THEN 0
        ELSE salary
    END AS bonus
FROM Employees
ORDER BY employee_id;



Type: IF Condition

1.

SELECT
    employee_id, 
    IF(employee_id % 2 = 1 AND NAME NOT LIKE 'M%',salary,0) AS bonus
FROM employees
ORDER BY employee_id;

UPDATE salary
SET sex = IF(sex = 'm','f','m');



Type: Update Command

1.

UPDATE salary
SET sex = IF(sex = 'm','f','m');

UPDATE salary
    SET sex = 
        CASE
            WHEN sex = 'm' THEN 'f'
            ELSE 'm'
        END;



Type: Delete and Where

1.

DELETE 
    p1
FROM person p1, person p2
WHERE
    p1.email = p2.email AND p1.id > p2.id;



Type: Group Concat

1. Group Sold Products By The Date

SELECT 
    sell_date,
    COUNT(DISTINCT product) AS num_sold,
    GROUP_CONCAT(DISTINCT product ORDER BY product) AS products
FROM activities
GROUP BY sell_date;



Type: Union

1. Employees With Missing Information

SELECT
    employee_id
FROM Employees
WHERE employee_id NOT IN (

    SELECT
        employee_id
    FROM Salaries
)

UNION

SELECT
    employee_id
FROM Salaries
WHERE employee_id NOT IN (

    SELECT
        employee_id
    FROM Employees
)

ORDER BY employee_id
;



Type: #Unpivot (not in MySql)

SELECT product_id,store,price
FROM Products
UNPIVOT
(
	price
	FOR store in (store1,store2,store3)
) AS T;



Node Question

select id,
    case when p_id is null then 'Root'
         when id in (select p_id from tree) then 'Inner'
         else 'Leaf'
    end as Type
from tree
order by id


Populate the data in this table.

create table bst (n int, p int);

insert into bst VALUES
(1, 2),
(3, 2),
(6, 8),
(9, 8),
(2, 5),
(8, 5),
(5, NULL)
;
Not quite right solution:

select n,
    case when p is null then 'Root'
         when n not in (select t.p from bst t) then 'Leaf'
         else 'Inner'
    end as node_type
from bst
order by n
;
It returns:

1	Inner
2	Inner
3	Inner
5	Root
6	Inner
8	Inner
9	Inner

The reason why it is wrong is because when n not in (select t.p from bst t) then 'Leaf' failed all the times. But why?
Because the NULL value in p column failed all the comparation according to:

x NOT IN (...) is defined as a series of comparisons between x and each of the values returned by the subquery. 
SQL uses three-value logic, for which the three possible values of a logical expression are true, false or unknown. 
Comparison of a value to a NULL is unknown and if any one of those NOT IN comparisons is unknown then the result is also deemed to be unknown.
Lesson Learnt: Do not use NOT IN (collection) if there is NULL value in this collection. Instead, try to use IN!

Here is the right solution after correction.

select n,
    case when p is null then 'Root'
         when n not in (select t.p from bst t where p is not null) then 'Leaf'
         else 'Inner'
    end as node_type
from bst
order by n
;
The running result is:

1	Leaf
2	Inner
3	Leaf
5	Root
6	Leaf
8	Inner
9	Leaf
In fact, a better solution is to use IN like below.

select n,
    case when p is null then 'Root'
         when n in (select p from bst) then 'Inner'
         else 'Leaf'
    end
from bst
order by n
;



Type: Subquery 

SELECT
(SELECT
    DISTINCT salary 
FROM Employee
ORDER BY salary DESC
LIMIT 1 OFFSET 1) AS SecondHighestSalary;

Why do we require the subquery in the first place:

The reason is, the later solution(using the subqueries) handles the case when there’s no second highest salary. 
In that case, it returns null, but, if we don’t use the subquery(the former solution), it will return an empty string "" in case there is no second highest salary.




    