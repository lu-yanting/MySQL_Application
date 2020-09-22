
# 1.联结
## 1.1 关系表
关系表的设计就是要保证把信息分解成多个表，一类数据一个表。各表通过某些常用的值（即关系设计中的关系互相关联）。
各关系表之间通过主键、外键进行关联。关系数据可以有效地存储和方便地处理。因此，关系数据库的可伸缩性远比非关系数据库要好。
<hr style=" border:solid; width:100px; height:1px;" color=#000000 size=1">

## 1.2 为什么要使用联结
数据存储在多个表中，要想用单条SELECT语句检索出数据，就要使用联结。使用特殊的语法，可以联结多个表返回一组输出，联结在运行时关联表中正确的行。
<hr style=" border:solid; width:100px; height:1px;" color=#000000 size=1">

# 2.创建联结
确定要联结的表及如何关联
![在这里插入图片描述](https://img-blog.csdnimg.cn/20200922110440276.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80OTk4NDA0NA==,size_16,color_FFFFFF,t_70#pic_center)
<hr style=" border:solid; width:100px; height:1px;" color=#000000 size=1">

## 2.1 where子句的重要性
在联结两个表时，实际上是将第一个表中的每一行与第二个表中的每一行配对。
where子句作为过滤条件，它只包含那些匹配给定条件（这里是联结条件）的行。
没有where子句，第一个表中的每个行将与第二个表中的每个行配对，而不管它们逻辑上是否可以配在一起。由没有联结条件的表关系返回的结果为**笛卡儿积**。检索出的行的数目将是第一个表中的行数乘以第二个表中的行数。
![在这里插入图片描述](https://img-blog.csdnimg.cn/20200922111615766.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80OTk4NDA0NA==,size_16,color_FFFFFF,t_70#pic_center)
<hr style=" border:solid; width:100px; height:1px;" color=#000000 size=1">

## 2.2 内部联结
![在这里插入图片描述](https://img-blog.csdnimg.cn/20200922141747364.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80OTk4NDA0NA==,size_16,color_FFFFFF,t_70#pic_center)
尽管使用WHERE子句定义联结的确比较简单，但是使用明确的联结语法inner join...on 能够确保不会忘记联结条件，有时候这样做也能影响性能。

<hr style=" border:solid; width:100px; height:1px;" color=#000000 size=1">

## 2.3 联结多个表
SQL对一条SELECT语句中可以联结的表的数目没有限制。首先列出所有表，然后定义表之间的关系。
![在这里插入图片描述](https://img-blog.csdnimg.cn/20200922143955947.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80OTk4NDA0NA==,size_16,color_FFFFFF,t_70#pic_center)
Mysql在运行时关联指定的每个表以处理联结。这种处理可能是非常耗费资源的，因此应该仔细，不要联结不必要的表。联结的表越多，性能下降越厉害。
<hr style=" border:solid; width:100px; height:1px;" color=#000000 size=1">

```sql
-- 用where子句联结两个表,确定要联结的表及如何关联
SELECT vend_name, prod_name, prod_price 
FROM vendors, products 
WHERE vendors.`vend_id`= products.`vend_id` 
ORDER BY vend_name, prod_name;

-- 没有where子句的联结,产生的结果数目是第一个表中的行数乘以第二个表中的行数
SELECT vend_name, prod_name, prod_price FROM vendors, products ORDER BY vend_name, prod_name;

-- 内部联结inner join表名on 条件
SELECT vend_name, prod_name, prod_price 
FROM vendors INNER JOIN products 
ON vendors.`vend_id`= products.`vend_id` 
ORDER BY vend_name,prod_name;	

-- 联结多个表
SELECT prod_name, vend_name, prod_price, quantity 
FROM products, vendors, orderitems
WHERE products.`vend_id`= vendors.`vend_id`
  AND orderitems.`prod_id` = products.`prod_id`
  AND order_num = 20005;

```

