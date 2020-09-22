
# 1.子查询
子查询：即嵌套在其他查询中的查询。
<hr style=" border:solid; width:100px; height:1px;" color=#000000 size=1">

# 2.利用子查询进行过滤
在使用子查询时，把子查询分解为多行并且适当地进行缩进，能极大地简化子查询的使用。
![在这里插入图片描述](https://img-blog.csdnimg.cn/20200922095839803.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80OTk4NDA0NA==,size_16,color_FFFFFF,t_70#pic_center)
<hr style=" border:solid; width:100px; height:1px;" color=#000000 size=1">

# 3.作为计算字段使用子查询
![在这里插入图片描述](https://img-blog.csdnimg.cn/20200922102559427.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80OTk4NDA0NA==,size_16,color_FFFFFF,t_70#pic_center)
相关子查询：涉及外部查询的子查询，只要列名可能有多义
性，就必须使用这种语法（表名和列名由一个句点分隔）。
where  A表.字段= B表.字段
<hr style=" border:solid; width:100px; height:1px;" color=#000000 size=1">


```sql
-- 子查询,分步骤先查出最里面的子查询，再一步步往外层查询
-- 第一步，检索包含物品TNT2的所有订单的编号
SELECT order_num FROM orderitems WHERE prod_id = 'TNT2';
-- 第二步，检索具有前一步骤列出的订单编号的所有客户的ID
SELECT cust_id FROM orders WHERE order_num IN (SELECT order_num FROM orderitems WHERE prod_id = 'TNT2');
-- 第三步，检索前一步骤返回的所有客户ID的客户信息
SELECT cust_name, cust_contact
FROM customers 
WHERE cust_id IN (SELECT cust_id 
                         FROM orders 
                         WHERE order_num IN (SELECT order_num 
	                                     FROM orderitems 
	                                     WHERE prod_id = 'TNT2'));

-- 将count(*)作为子查询,orders是一个计算字段
SELECT cust_name, 
       cust_state,
       (SELECT COUNT(*) 
        FROM orders 
        WHERE orders.`cust_id`= customers.`cust_id`) AS orders 
FROM customers 
ORDER BY cust_name ;

```

