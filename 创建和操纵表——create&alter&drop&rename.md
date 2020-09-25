
# 1. 创建表
表创建的方法一般有两种：
1、使用具有交互式创建和管理表的工具；
2、表也可以直接用MySQL语句操纵。

## 1.1 表创建基础
![在这里插入图片描述](https://img-blog.csdnimg.cn/20200924165020743.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80OTk4NDA0NA==,size_16,color_FFFFFF,t_70#pic_center)

表名紧跟在create table关键字后面。实际的表定义（所有列）括在圆括号之中。各列之间用逗号分隔。这个表由9列组成。每列的定义以列名（它在表中必须是唯一的）开始，后跟列的数据类型。表的主键可以在创建表时用primary key关键字指定。整条语句由右圆括号后的分号结束。
<hr style=" border:solid; width:100px; height:1px;" color=#000000 size=1">

## 1.2 使用NULL值
允许NULL值的列也允许在插入行时不给出该列的值。不允许NULL值的列不接受该列没有值的行。

每个表列的NULL或NOT NULL状态在创建时由表的定义规定。

![在这里插入图片描述](https://img-blog.csdnimg.cn/20200924171507129.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80OTk4NDA0NA==,size_16,color_FFFFFF,t_70#pic_center)
NULL为默认设置，如果不指定NOT NULL，则认为指定的是NULL。

不要把NULL值与空串相混淆。NULL值是没有值，它不是空串。如果指定''（两个单引号，其间没有字符），这在NOT NULL列中是允许的。空串是一个有效的值，它不是无值。NULL值用关键字NULL而不是空串指定。
<hr style=" border:solid; width:100px; height:1px;" color=#000000 size=1">

## 1.3 主键再介绍
主键值必须唯一，主键可用单个列，也可用多个列，但是值必须唯一。并且主键中只能使用不允许NULL值的列。
主键值的语句定义：primary key(vend_id)

![在这里插入图片描述](https://img-blog.csdnimg.cn/20200925101935185.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80OTk4NDA0NA==,size_16,color_FFFFFF,t_70#pic_center)
主键可以在创建表时定义，或者在创建表之后定义。
<hr style=" border:solid; width:100px; height:1px;" color=#000000 size=1">

## 1.4 使用auto_increment
auto_increment告诉MySQL，本列每当增加一行时自动增量。每次执行一个insert操作时，MySQL自动对该列增量（从而才有这个关键字auto_increment），给该列赋予下一个可用的值。
每个表只允许一个auto_increment列，而且它必须被索引（如，通过使它成为主键）。

![在这里插入图片描述](https://img-blog.csdnimg.cn/20200925110321131.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80OTk4NDA0NA==,size_16,color_FFFFFF,t_70#pic_center)

auto_increment可以被覆盖：只要在insert语句中指定一个值，只要它是唯一的（至今尚未使用过）即可，该值将被用来替代自动生成的值。后续的增量将开始使用该手工插入的值。

如何在使用auto_increment列时获得这个值呢？可使用last_insert_id()函数获得这个值：select last_insert_id()，此语句返回最后一个auto_increment值，然后可以将它用于后续的MySQL语句。
<hr style=" border:solid; width:100px; height:1px;" color=#000000 size=1">

## 1.5 指定默认值
如果在插入行时没有给出值，MySQL允许指定此时使用的默认值。默认值用create table语句的列定义中的default关键字指定。

![在这里插入图片描述](https://img-blog.csdnimg.cn/20200925111021410.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80OTk4NDA0NA==,size_16,color_FFFFFF,t_70#pic_center)
MySQL不允许使用函数作为默认值，它只支持常量。
<hr style=" border:solid; width:100px; height:1px;" color=#000000 size=1">

## 1.6 引擎类型
与其他DBMS一样，MySQL有一个具体管理和处理数据的内部引擎。在你使用create table语句时，该引擎具体创建表，而在你使用select语句或进行其他数据库处理时，该引擎在内部处理你的请求。

通常用到的引擎有以下几种：

 1. InnoDB是一个可靠的事务处理引擎，它不支持全文本搜索；
 2. MEMORY在功能等同于MyISAM，但由于数据存储在内存（不是磁盘）中，速度很快（特别适合于临时表）；
 3. MyISAM是一个性能极高的引擎，它支持全文本搜索，但不支持事务处理。
 
 引擎类型可以混用。但是混用引擎类型有一个大缺陷。外键（用于强制实施引用完整性）不能跨引擎，即使用一个引擎的表不能引用具有使用不同引擎的表的外键。
<hr style=" border:solid; width:100px; height:1px;" color=#000000 size=1">

#  2. 更新表
为了使用alter table更改表结构，必须给出下面的信息：	
 1、在alter table之后给出要更改的表名（该表必须存在，否则将出错）；
2、所做更改的列表。

![在这里插入图片描述](https://img-blog.csdnimg.cn/20200925145108117.png#pic_center)

![在这里插入图片描述](https://img-blog.csdnimg.cn/20200925145306766.png#pic_center)

alter table的一种常见用途是定义外键。

![在这里插入图片描述](https://img-blog.csdnimg.cn/20200925145851566.png#pic_center)

复杂的表结构更改一般需要手动删除过程，它涉及以下步骤：

 1. 用新的列布局创建一个新表；
 2. 使用insert select语句从旧表复制数据到新表。如果有必要，可使用转换函数和计算字段；
 3. 检验包含所需数据的新表；
 4. 重命名旧表（如果确定，可以删除它）；
 5. 用旧表原来的名字重命名新表；
 6. 根据需要，重新创建触发器、存储过程、索引和外键。
 
使用alter table要极为小心，应该在进行改动前做一个完整的备份（模式和数据的备份）。数据库表的更改不能撤销，如果增加了不需要的列，可能不能删除它们。类似地，如果删除了不应该删除的列，可能会丢失该列中的所有数据。
<hr style=" border:solid; width:100px; height:1px;" color=#000000 size=1">

# 3. 删除表
删除表（删除整个表而不是其内容）非常简单，使用drop table语句即可：drop table 表名;

删除表没有确认，也不能撤销，执行这条语句将永久删除该表。
<hr style=" border:solid; width:100px; height:1px;" color=#000000 size=1">

# 4. 重命名表
使用rename table语句可以重命名表：rename table 表名1 to 表名2;

如果有多个表需要重命名，用逗号分隔，如下：

![在这里插入图片描述](https://img-blog.csdnimg.cn/2020092515230618.png#pic_center)

<hr style=" border:solid; width:100px; height:1px;" color=#000000 size=1">

```sql
-- 创建表create table,定义列为NULL还是NOT NULL
 CREATE TABLE mydatabase.customers
 (
     cust_id INT NOT NULL AUTO_INCREMENT,
     cust_name CHAR(50) NOT NULL,
     cust_address CHAR(50) NULL,
     cust_city CHAR(50) NULL,
     cust_state CHAR(5) NULL,
     cust_contact CHAR(50) NULL,
     cust_email CHAR(255) NULL,
     PRIMARY KEY(cust_id)
  )ENGINE = INNODB;
  
  
  -- 2020-09-25 
  -- 由多个列组成的主键
  CREATE TABLE orderitems 
  (
    order_num   INT    NOT NULL,
    order_item  INT    NOT NULL,
    prod_id     CHAR(10) NOT NULL,
    quantity    INT    NOT NULL,
    item_price  DECIMAL(8,2) NOT NULL,
    PRIMARY KEY (order_num, order_item)
   ) ENGINE=INNODB;
   
  
-- auto_increment，自动增量
 CREATE TABLE mydatabase.customers
 (
     cust_id INT NOT NULL AUTO_INCREMENT,
     cust_name CHAR(50) NOT NULL,
     cust_address CHAR(50) NULL,
     cust_city CHAR(50) NULL,
     cust_state CHAR(5) NULL,
     cust_contact CHAR(50) NULL,
     cust_email CHAR(255) NULL,
     PRIMARY KEY(cust_id)
  )ENGINE = INNODB;  
  
  -- default，设置默认值
  CREATE TABLE orderitems 
  (
    order_num   INT    NOT NULL,
    order_item  INT    NOT NULL,
    prod_id     CHAR(10) NOT NULL,
    quantity    INT    NOT NULL  DEFAULT 1,
    item_price  DECIMAL(8,2) NOT NULL,
    PRIMARY KEY (order_num, order_item)
   ) ENGINE=INNODB;
  
  -- alter，给表增加一列
  ALTER TABLE vendors 
  ADD vend_phone CHAR(20);
  
  -- alter，删除刚添加的列
  ALTER TABLE vendors
  DROP COLUMN vend_phone;
  
  -- 用alter table 定义外键
  ALTER TABLE orderitems 
  ADD CONSTRAINT fk_orderitems_orders
  FOREIGN KEY (order_num) REFERENCES orders (order_num);
  
  -- rename，重命名表
  RENAME TABLE backup_customers TO customers,
               backup_vendors TO vendors,
               backup_products TO products;
```

