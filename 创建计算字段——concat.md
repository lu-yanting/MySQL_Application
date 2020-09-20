@[TOC]
#  1、计算字段
计算字段并不实际存在于数据库表中。计算字段是运行时在SELECT语句内创建的。
需要注意的是，只有数据库知道SELECT语句中哪些列是实际的表列，哪些列是计算字段。从客户机（如应用程序）的角度来看，计算字段的数据是以与其他列的数据相同的方式返回的。
#  2、拼接字段
在MySQL的SELECT语句中，可使用Concat()函数来拼接两个列。
多数DBMS使用+或||来实现拼接，MySQL则使用Concat()函数来实现。当把SQL语句转换成MySQL语句时一定要把这个区别铭记在心。
![在这里插入图片描述](https://img-blog.csdnimg.cn/20200919143504447.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80OTk4NDA0NA==,size_16,color_FFFFFF,t_70#pic_center)

在用concat拼接串时，为删除数据多余的空格来整理数据，这可以使用MySQL的Trim()函数来完成。RTrim()函数去掉值右边的所有空格，LTrim()函数去掉串左边的空格，Trim()函数去掉串左右两边的空格。
![在这里插入图片描述](https://img-blog.csdnimg.cn/2020091914363825.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80OTk4NDA0NA==,size_16,color_FFFFFF,t_70#pic_center)

##  2.1使用别名
前面已经做了拼接，但是它没有名字，它只是一个值。一个未
命名的列不能用于客户机应用中，因为客户机没有办法引它。
为了解决这个问题，SQL支持列别名。别名是一个字段或值的替换名。别名用AS关键字赋予。有了别名后，任何客户机应用都可以按名引用这个列，就像它是一个实际的表列一样。
![在这里插入图片描述](https://img-blog.csdnimg.cn/20200919143800346.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80OTk4NDA0NA==,size_16,color_FFFFFF,t_70#pic_center)
别名还有其他用途。常见的用途包括在实际的表列名包含不符合规定的字符（如空格）时重新命名它，在原来的名字含混或容易误解时扩充它。
# 3、执行算数计算
计算字段的另一常见用途是对检索出的数据进行算术计算。
![在这里插入图片描述](https://img-blog.csdnimg.cn/20200919153342548.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80OTk4NDA0NA==,size_16,color_FFFFFF,t_70#pic_center)
MySQL支持的基本算术操作符有+、-、*、\。此外，圆括号可用来区分优先顺序。

```sql
USE lu_test;

-- 按照name(location)这样的格式列出供应商的位置
SELECT CONCAT (vend_name, '(', vend_country, ')') FROM vendors ORDER BY vend_name;

-- 拼接串时，可用trim(函数）去除多余空格
SELECT CONCAT (RTRIM(vend_name), '(', TRIM(vend_country), ')') FROM vendors ORDER BY vend_name;

-- 赋予别名
SELECT CONCAT (RTRIM(vend_name), '(', TRIM(vend_country), ')') AS vend_title FROM vendors ORDER BY vend_name;

-- 汇总计算物品的价格
SELECT prod_id, quantity, item_price, quantity*item_price AS expanded_price FROM orderitems WHERE order_num = 20005;

```







