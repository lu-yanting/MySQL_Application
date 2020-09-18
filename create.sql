########################################
# MySQL Crash Course
# http://www.forta.com/books/0672327120/
# Example table creation scripts
########################################


########################
# Create customers table
########################
DROP DATABASE IF EXISTS lu_test;
CREATE DATABASE IF NOT EXISTS lu_test;

USE lu_test;

CREATE TABLE customers
(
  cust_id      INT       NOT NULL AUTO_INCREMENT,
  cust_name    CHAR(50)  NOT NULL ,
  cust_address CHAR(50)  NULL ,
  cust_city    CHAR(50)  NULL ,
  cust_state   CHAR(5)   NULL ,
  cust_zip     CHAR(10)  NULL ,
  cust_country CHAR(50)  NULL ,
  cust_contact CHAR(50)  NULL ,
  cust_email   CHAR(255) NULL ,
  PRIMARY KEY (cust_id)
) ENGINE=INNODB;

#########################
# Create orderitems table
#########################
CREATE TABLE orderitems
(
  order_num  INT          NOT NULL ,
  order_item INT          NOT NULL ,
  prod_id    CHAR(10)     NOT NULL ,
  quantity   INT          NOT NULL ,
  item_price DECIMAL(8,2) NOT NULL ,
  PRIMARY KEY (order_num, order_item)
) ENGINE=INNODB;


#####################
# Create orders table
#####################
CREATE TABLE orders
(
  order_num  INT      NOT NULL AUTO_INCREMENT,
  order_date DATETIME NOT NULL ,
  cust_id    INT      NOT NULL ,
  PRIMARY KEY (order_num)
) ENGINE=INNODB;

#######################
# Create products table
#######################
CREATE TABLE products
(
  prod_id    CHAR(10)      NOT NULL,
  vend_id    INT           NOT NULL ,
  prod_name  CHAR(255)     NOT NULL ,
  prod_price DECIMAL(8,2)  NOT NULL ,
  prod_desc  TEXT          NULL ,
  PRIMARY KEY(prod_id)
) ENGINE=INNODB;

######################
# Create vendors table
######################
CREATE TABLE vendors
(
  vend_id      INT      NOT NULL AUTO_INCREMENT,
  vend_name    CHAR(50) NOT NULL ,
  vend_address CHAR(50) NULL ,
  vend_city    CHAR(50) NULL ,
  vend_state   CHAR(5)  NULL ,
  vend_zip     CHAR(10) NULL ,
  vend_country CHAR(50) NULL ,
  PRIMARY KEY (vend_id)
) ENGINE=INNODB;

###########################
# Create productnotes table
###########################
CREATE TABLE productnotes
(
  note_id    INT           NOT NULL AUTO_INCREMENT,
  prod_id    CHAR(10)      NOT NULL,
  note_date DATETIME       NOT NULL,
  note_text  TEXT          NULL ,
  PRIMARY KEY(note_id),
  FULLTEXT(note_text)
) ENGINE=MYISAM;


#####################
# Define foreign keys
#####################
ALTER TABLE orderitems ADD CONSTRAINT fk_orderitems_orders FOREIGN KEY (order_num) REFERENCES orders (order_num);
ALTER TABLE orderitems ADD CONSTRAINT fk_orderitems_products FOREIGN KEY (prod_id) REFERENCES products (prod_id);
ALTER TABLE orders ADD CONSTRAINT fk_orders_customers FOREIGN KEY (cust_id) REFERENCES customers (cust_id);
ALTER TABLE products ADD CONSTRAINT fk_products_vendors FOREIGN KEY (vend_id) REFERENCES vendors (vend_id);