
# 1.数据插入
insert是用来插入（或添加）行到数据库表的。
插入可以用几种方式使用：

 1. 插入完整的行；
 2. 插入行的一部分；
 3. 插入多行；
 4. 插入某些查询的结果。
 <hr style=" border:solid; width:100px; height:1px;" color=#000000 size=1">
 
#  2. 插入完整的行
![在这里插入图片描述](https://img-blog.csdnimg.cn/20200924111150499.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80OTk4NDA0NA==,size_16,color_FFFFFF,t_70#pic_center)

以上这种语法很简单，但并不安全，应该尽量避免使用。上面的SQL语句高度依赖于表中列的定义次序，并且还依赖于其次序容易获得的信息。即使可得到这种次序信息，也不能保证下一次表结构变动后各个列保持完全相同的次序。因此，编写依赖于特定列次序的SQL语句是很不安全的。

编写insert语句的更安全（不过更烦琐）的方法如下：
![在这里插入图片描述](https://img-blog.csdnimg.cn/2020092411194396.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80OTk4NDA0NA==,size_16,color_FFFFFF,t_70#pic_center)
因为提供了列名，VALUES必须以其指定的次序匹配指定的列名，不一定按各个列出现在实际表中的次序。其优点是，即使表的结构改变，此insert语句仍然能正确工作。其中cust_id的NULL值是不必要的，cust_id列并没有出现在列表中，所以不需要任何值。

如果表的定义允许，则可以在insert操作中省略某
些列。省略的列必须满足以下条件：

 1. 该列定义为允许NULL值（无值或空值）。
 2. 在表定义中给出默认值。这表示如果不给出值，将使用默
认值。

insert操作可能很耗时（特别是有很多索引需要更新时），而且它可能降低等待处理的SELECT语句的性能。
如果数据检索是最重要的（通常是这样），则你可以通过在
insert和into之间添加关键字low_priority：insert low_priority into，指示MySQL降低insert语句的优先级。
<hr style=" border:solid; width:100px; height:1px;" color=#000000 size=1">

# 3. 插入多个行
用多条insert语句，一次提交它们，每条语句用一个分号结束。
![在这里插入图片描述](https://img-blog.csdnimg.cn/20200924141844286.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80OTk4NDA0NA==,size_16,color_FFFFFF,t_70#pic_center)
如果每条insert中的列名（和次序）相同，可以如下组合语句,其中单条insert语句有多组值，每组值用一对圆括号括起来，用逗号分隔。
此技术可以提高数据库处理的性能，因为MySQL用单条insert语句处理多个插入比使用多条insert语句快。

![在这里插入图片描述](https://img-blog.csdnimg.cn/2020092414285633.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80OTk4NDA0NA==,size_16,color_FFFFFF,t_70#pic_center)
<hr style=" border:solid; width:100px; height:1px;" color=#000000 size=1">

# 4. 插入检索出的数据
insert还可将一条select语句的结果插入表中——insert select。

![在这里插入图片描述](https://img-blog.csdnimg.cn/20200924144935928.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80OTk4NDA0NA==,size_16,color_FFFFFF,t_70#pic_center)

以上这个例子在insert和select语句中使用了相同的列名。但是，不一定要求列名匹配。事实上，MySQL甚至不关心select返回的列名。它使用的是列的位置，因此select中的第一列（不管其列名）将用来填充表列中指定的第一个列，第二列将用来填充表列中指定的第二个列，如此等等。这对于从使用不同列名的表中导入数据是非常有用的。

insert select中elect语句可包含where子句以过滤插入的数据。
<hr style=" border:solid; width:100px; height:1px;" color=#000000 size=1">

```sql
-- insert,没有指定列名，按表中列的定义次序
 INSERT INTO customers
 VALUES (NULL,
 'Pep E.LaPew',
 '100 Main Street',
 'Los Angeles',
 'CA',
 '90046',
 'USA',
 NULL,
 NULL);
 
 -- insert，指定列名，再定义值
 INSERT INTO customers (cust_name,
    cust_address,
    cust_city,
    cust_state,
    cust_zip,
    cust_country,
    cust_contact,
    cust_email)
 VALUES('Pep E.LaPew',
 '100 Main Street',
 'Los Angeles',
 'CA',
 '90046',
 'USA',
 NULL,
 NULL);
 
 -- 多条insert语句
 INSERT INTO customers (cust_name,
    cust_address,
    cust_city,
    cust_state,
    cust_zip,
    cust_country)
 VALUES('Pep E.LaPew',
 '100 Main Street',
 'Los Angeles',
 'CA',
 '90046',
 'USA');
 INSERT INTO customers (cust_name,
    cust_address,
    cust_city,
    cust_state,
    cust_zip,
    cust_country)
 VALUES('M.Martian',
 '42 Galaxy Way',
 'New York',
 'NY',
 '11213',
 'USA');
 
 -- 每条insert中的列名（和次序）相同，可以简化组合语句
 INSERT INTO customers (cust_name,
    cust_address,
    cust_city,
    cust_state,
    cust_zip,
    cust_country)
 VALUES(
    'Pep E.LaPew',
    '100 Main Street',
    'Los Angeles',
    'CA',
    '90046',
    'USA'
   ),
   ( 
    'M.Martian',
    '42 Galaxy Way',
    'New York',
    'NY',
    '11213',
    'USA'
  );
  
  -- insert select
  INSERT INTO customers (cust_id,
     cust_contact,
     cust_email,
     cust_name,
     cust_address,
     cust_city,
     cust_state,
     cust_zip,
     cust_country)
  SELECT cust_id,
     cust_contact,
     cust_email,
     cust_name,
     cust_address,
     cust_city,
     cust_state,
     cust_zip,
     cust_country
  FROM custnew;
```






