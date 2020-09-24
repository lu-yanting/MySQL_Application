
# 1. 更新数据
为了更新（修改）表中的数据，可使用update语句。可采用两种方式使用update：
1、 更新表中特定行；
2、 更新表中所有行。

基本的update语句由3部分组成，分别是：

 1. 要更新的表；
 2. 列名和它们的新值；
 3. 确定要更新行的过滤条件。
 
 ![在这里插入图片描述](https://img-blog.csdnimg.cn/20200924155031155.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80OTk4NDA0NA==,size_16,color_FFFFFF,t_70#pic_center)
在更新多个列时，只需要使用单个set命令，每个“列=值”对之间用逗号分隔（最后一列之后不用逗号）

![在这里插入图片描述](https://img-blog.csdnimg.cn/20200924155422106.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80OTk4NDA0NA==,size_16,color_FFFFFF,t_70#pic_center)
update语句中可以使用子查询，使得能用select语句检索出的数据更新列数据。
 
 为了删除某个列的值，可设置它为NULL（假如表定义允许NULL值）。![在这里插入图片描述](https://img-blog.csdnimg.cn/202009241604519.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80OTk4NDA0NA==,size_16,color_FFFFFF,t_70#pic_center)
<hr style=" border:solid; width:100px; height:1px;" color=#000000 size=1">

# 2. 删除数据
为了从一个表中删除（去掉）数据，使用delete语句。可以两种方式使用delete：
1、从表中删除特定的行；
2、从表中删除所有行。

![在这里插入图片描述](https://img-blog.csdnimg.cn/2020092416121121.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80OTk4NDA0NA==,size_16,color_FFFFFF,t_70#pic_center)
delete不需要列名或通配符。delete删除整行而不是删除列。为了删除指定的列，请使用update语句。

delete语句从表中删除行，甚至是删除表中所有行。但是，delete不删除表本身。如果想从表中删除所有行，不要使用delete。可使用truncate table语句，它完成相同的工作，但速度更快（truncate实际是删除原来的表并重新创建一个表，而不是逐行删除表中的数据）。
<hr style=" border:solid; width:100px; height:1px;" color=#000000 size=1">

# 3. 更新和删除的指导原则

 1. 除非确实打算更新和删除每一行，否则绝对不要使用不带where子句的update或delete语句。
 2. 保证每个表都有主键，尽可能像where子句那样使用它（可以指定各主键、多个值或值的范围）。
 3. 在对update或delete语句使用where子句前，应该先用select进行测试，保证它过滤的是正确的记录，以防编写的where子句不正确。
 4. 使用强制实施引用完整性的数据库，这样MySQL将不允许删除具有与其他表相关联的数据的行。
 5. MySQL没有撤销按钮。应该非常小心地使用update和delete。
 
 <hr style=" border:solid; width:100px; height:1px;" color=#000000 size=1">

```sql
-- update，更新客户10005的邮箱地址
 UPDATE customers 
 SET cust_email = 'elmer@fudd.com'
 WHERE cust_id = 10005;
 
 -- 更新多个列
 UPDATE customers 
 SET  cust_name = 'The fudds' ,
      cust_email = 'elmer@fudd.com'
 WHERE cust_id = 10005;
 
 -- 为了删除某个列的值，可设置它为NULL（假如表定义允许NULL值）。
 UPDATE customers 
 SET cust_email = NULL
 WHERE cust_id = 10005;
 
 -- delete
 DELETE FROM customers 
 WHERE cust_id = 10006;

```

