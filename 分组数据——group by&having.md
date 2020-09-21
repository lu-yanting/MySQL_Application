
# 1.数据分组
分组允许把数据分为多个逻辑组，以便能对每个组进行聚集计算。
<hr style=" border:solid; width:100px; height:1px;" color=#000000 size=1">

#  2.创建分组
![在这里插入图片描述](https://img-blog.csdnimg.cn/20200921102431832.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80OTk4NDA0NA==,size_16,color_FFFFFF,t_70#pic_center)
group by 的一些重要规定：

 1. group by子句可以包含任意数目的列。这使得能对分组进行嵌套，为数据分组提供更细致的控制。
 2. 如果在group by子句中嵌套了分组，数据将在最后规定的分组上进行汇总。换句话说，在建立分组时，指定的所有列都一起计算（所以不能从个别的列取回数据）。
 3. group by子句中列出的每个列都必须是检索列或有效的表达式（但不能是聚集函数）。如果在select中使用表达式，则必须在group by子句中指定相同的表达式。不能使用别名。
 4. 除聚集计算语句外，select语句中的每个列都必须在group by子句中给出。
 5. 如果分组列中具有null值，则null将作为一个分组返回。如果列中有多行null值，它们将分为一组。
 6. group by子句必须出现在where子句之后，order by子句之前。
 
![在这里插入图片描述](https://img-blog.csdnimg.cn/20200921104036159.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80OTk4NDA0NA==,size_16,color_FFFFFF,t_70#pic_center)
<hr style=" border:solid; width:100px; height:1px;" color=#000000 size=1">

# 3. 过滤分组
where过滤行，而having过滤分组。
![在这里插入图片描述](https://img-blog.csdnimg.cn/20200921105513603.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80OTk4NDA0NA==,size_16,color_FFFFFF,t_70#pic_center)
![在这里插入图片描述](https://img-blog.csdnimg.cn/20200921214232242.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80OTk4NDA0NA==,size_16,color_FFFFFF,t_70#pic_center)
<hr style=" border:solid; width:100px; height:1px;" color=#000000 size=1">

#  4.分组和排序
order by 和 group by 的区别：
![在这里插入图片描述](https://img-blog.csdnimg.cn/20200921215646970.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80OTk4NDA0NA==,size_16,color_FFFFFF,t_70#pic_center)
一般在使用group by子句时，应该也给出order by子句。这是保证数据正确排序的唯一方法。千万不要仅依赖group by排序数据。

![在这里插入图片描述](https://img-blog.csdnimg.cn/20200921220824392.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80OTk4NDA0NA==,size_16,color_FFFFFF,t_70#pic_center)
<hr style=" border:solid; width:100px; height:1px;" color=#000000 size=1">

# 5.select子句顺序
select子句及其顺序：
![在这里插入图片描述](https://img-blog.csdnimg.cn/20200921222046475.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80OTk4NDA0NA==,size_16,color_FFFFFF,t_70#pic_center)![在这里插入图片描述](https://img-blog.csdnimg.cn/20200921222238618.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80OTk4NDA0NA==,size_16,color_FFFFFF,t_70#pic_center)
<hr style=" border:solid; width:100px; height:1px;" color=#000000 size=1">

```sql
-- gropu by分组
SELECT vend_id, COUNT(*) AS num_prods FROM products GROUP BY vend_id;

-- 使用with rollup得到每个分组汇总级别的值
SELECT vend_id, COUNT(*) AS num_prods FROM products GROUP BY vend_id WITH ROLLUP;

-- having分组
SELECT cust_id, COUNT(*) AS orders FROM orders GROUP BY cust_id HAVING COUNT(*) >= 2;

-- 同时使用where、group by、having
SELECT vend_id, COUNT(*) AS num_prods FROM products WHERE prod_price >= 10 GROUP BY vend_id HAVING COUNT(*) >= 2;

-- 同时使用group by和order by，按总计订单价格排序输出，需要添加order by
SELECT order_num, SUM(quantity*item_price) AS ordertotal 
	FROM orderitems 
		GROUP BY order_num 
		HAVING SUM(quantity*item_price) >= 50 
		ORDER BY ordertotal;

```



