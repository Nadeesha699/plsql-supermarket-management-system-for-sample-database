--01.Create tables with primary key and foreign key constraints having auto-increment sequence for one of the tables--
-- Create Customers table
CREATE TABLE Customers (
  customer_id NUMBER PRIMARY KEY,
  customer_name1 VARCHAR2(50),
  email VARCHAR2(50)
);

-- Create Orders table
CREATE TABLE Orders (
  order_id NUMBER PRIMARY KEY,
  order_date DATE,
  customer_id NUMBER,
  amount NUMBER(8,2),
  CONSTRAINT fk_customer
    FOREIGN KEY (customer_id)
    REFERENCES Customers(customer_id)
);

-- Create OrderItems table
CREATE TABLE OrderItems (
  item_id NUMBER PRIMARY KEY,
  order_id NUMBER,
  product_name1 VARCHAR2(50),
  quantity NUMBER,
  price NUMBER(8,2),
  CONSTRAINT fk_order
    FOREIGN KEY (order_id)
    REFERENCES Orders(order_id)
);

--02Insert a set of matching records for the above tables.--
set serveroutput on;
BEGIN
  -- Insert records into Customers table
  INSERT INTO Customers (customer_id, customer_name1, email)
  VALUES (1, 'John Doe', 'johndoe@gmail.com');

  INSERT INTO Customers (customer_id, customer_name1, email)
  VALUES (2, 'Jane Smith', 'janesmith@gmail.com');

  INSERT INTO Customers (customer_id, customer_name1, email)
  VALUES (3, 'Kasun Rajitha', 'kasun@gmail.com');

  INSERT INTO Customers (customer_id, customer_name1, email)
  VALUES (4, 'Heda Filler', 'heda@gmail.com');

  INSERT INTO Customers (customer_id, customer_name1, email)
  VALUES (5, 'carren Hiller', 'carren@gmail.com');
  -- Insert records into Orders table
  INSERT INTO Orders (order_id, order_date, customer_id, amount)
  VALUES (1, SYSDATE, 1, 2500.00);

  INSERT INTO Orders (order_id, order_date, customer_id, amount)
  VALUES (2, SYSDATE, 2, 3000.50);
  
  INSERT INTO Orders (order_id, order_date, customer_id, amount)
  VALUES (3, SYSDATE, 3, 4500.22);

  INSERT INTO Orders (order_id, order_date, customer_id, amount)
  VALUES (4, SYSDATE, 4, 2145.21);

  INSERT INTO Orders (order_id, order_date, customer_id, amount)
  VALUES (5, SYSDATE, 5, 6012.20);
  -- Insert records into OrderItems table
  INSERT INTO OrderItems (item_id, order_id, product_name1, quantity, price)
  VALUES (1, 1, 'Product A', 5, 200.21);

  INSERT INTO OrderItems (item_id, order_id, product_name1, quantity, price)
  VALUES (2, 1, 'Product B', 3, 512.12);

  INSERT INTO OrderItems (item_id, order_id, product_name1, quantity, price)
  VALUES (3, 2, 'Product C', 2, 230.12);

  INSERT INTO OrderItems (item_id, order_id, product_name1, quantity, price)
  VALUES (4, 3, 'Product D', 7, 320.00);

INSERT INTO OrderItems (item_id, order_id, product_name1, quantity, price)
  VALUES (5, 3, 'Product E', 10, 245.20);
  COMMIT; -- Commit the transaction
END;
/

--03.Write any select queries each using where, group by, having, and order by.--
-- PL/SQL block with select queries

BEGIN
  -- Select a specific customer using WHERE
  SELECT *
  FROM OrderItems
  WHERE product_name1 ='Product E' ;

  -- Group orders by customer_id and calculate the total number of orders per customer using GROUP BY
  SELECT customer_id, COUNT(*) AS total_orders
  FROM Orders
  GROUP BY customer_id;

  -- Select customers who have ordered more than 2500  amount using HAVING
  SELECT customer_id, SUM(amount) AS total_amount
  FROM Orders
  GROUP BY customer_id
  HAVING SUM(amount) > 2500;
  
  -- Select orders sorted by amount in ascending order using ORDER BY
  SELECT *
  FROM Orders
  ORDER BY amount  ASC;
END;
/

--04--
-- PL/SQL block with single-row and multiple-row subqueries
set serveroutput on;
DECLARE
  v_customer_name Customers.customer_name1%TYPE;
  v_total_quantity OrderItems.quantity%TYPE;
BEGIN
  -- Single-row subquery: Select the customer name for a specific order using subquery
  SELECT customer_name1 INTO v_customer_name
  FROM Customers
  WHERE customer_id = (SELECT customer_id FROM Orders WHERE order_id = 1);

  -- Multiple-row subquery: Select the total quantity of items for a specific order using subquery
  SELECT SUM(quantity) INTO v_total_quantity
  FROM OrderItems
  WHERE order_id <= ALL (SELECT order_id FROM Orders WHERE order_id=1);

  DBMS_OUTPUT.PUT_LINE('Customer Name: ' || v_customer_name);
  DBMS_OUTPUT.PUT_LINE('Total Quantity: ' || v_total_quantity);
END;
/

--05.Write queries using left, right, and full outer joins. (There should be suitable records inserted to get the required outputs)--
set serveroutput on;
BEGIN
  -- Left join: Select all customers and their corresponding orders (if any)
  SELECT c.customer_id, c.customer_name1, o.order_id, o.order_date
  FROM Customers c
  LEFT JOIN Orders o 
  ON c.customer_id = o.customer_id;

  -- Right join: Select all orders and their corresponding customers (if any)
  SELECT c.customer_id, c.customer_name1, o.order_id, o.order_date
  FROM Customers c
  RIGHT JOIN Orders o ON c.customer_id = o.customer_id;

  -- Full outer join: Select all customers and orders, including unmatched records from both tables
  SELECT c.customer_id, c.customer_name1, o.order_id, o.order_date
  FROM Customers c
  FULL OUTER JOIN Orders o ON c.customer_id = o.customer_id;
END;
/

--06. Create a view using one of the tables created.--
CREATE VIEW orders_views AS
SELECT order_id,order_date,customer_id,amount
FROM Orders
WHERE amount> 1500;

select * from orders_views;

--07.Write a PL/ SQL block to retrieve a record for specific input.--
-- PL/SQL block to retrieve a record based on customer_id
set serveroutput on;
DECLARE
  v_customer_name Customers.customer_name1%TYPE;
BEGIN
  SELECT customer_name1 INTO v_customer_name
  FROM Customers
  WHERE customer_id = 1;

  DBMS_OUTPUT.PUT_LINE('Customer Name: ' || v_customer_name);
END;
/

--08.Write a PL/ SQL block to update a record for specific input--
-- PL/SQL block to update a customer's email based on customer_id
DECLARE
  v_customer_id Customers.customer_id%TYPE := 1;
  v_new_email Customers.email%TYPE := 'newemail@gmail.com';
BEGIN
  UPDATE Customers
  SET email = v_new_email
  WHERE customer_id = v_customer_id;

  DBMS_OUTPUT.PUT_LINE('Customer email updated.');
  
END;
/

Select email from customers where customer_id=1;

--09.Write a PL/ SQL block to delete a record for specific input.--
-- PL/SQL block to delete a customer record based on customer_id
DECLARE
  v_item_id  OrderItems.item_id %TYPE := 1;
BEGIN
  DELETE FROM OrderItems
  WHERE   item_id = v_item_id;

  DBMS_OUTPUT.PUT_LINE('Orderitem record deleted.');
END;
/
select * from OrderItems;

--10.Modify the above query to display the number of rows deleted.--
DECLARE
  v_item_id OrderItems.item_id%TYPE := 2;
  v_rows_deleted NUMBER;
BEGIN
  DELETE FROM OrderItems
  WHERE item_id = v_item_id;
  
  v_rows_deleted := SQL%ROWCOUNT;
  
  DBMS_OUTPUT.PUT_LINE('Number of rows deleted: ' || v_rows_deleted);
END;
/
