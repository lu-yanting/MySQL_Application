
# 1. 触发器
触发器是MySQL响应以下任意语句而自动执行的一条MySQL语句（或位于BEGIN和END语句之间的一组语句）：delete、insert、update。
其他MySQL语句不支持触发器。
<hr style=" border:solid; width:100px; height:1px;" color=#000000 size=1">

# 2.创建触发器
在创建触发器时，需要给出4条信息：

 - 唯一的触发器名：在每个表中唯一，而不是在每个数据库中唯一；
 - 触发器关联的表；
 - 触发器应该响应的活动（delete、insert或update）；
 - 触发器何时执行（处理之前或之后）。
 
 触发器用create trigger语句创建。MYSQL5以后，不允许触发器返回任何结果，因此使用into @变量名，将结果赋值到变量中，用select调用即可。
 ![在这里插入图片描述](https://img-blog.csdnimg.cn/20201006112248387.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80OTk4NDA0NA==,size_16,color_FFFFFF,t_70#pic_center)

触发器可在一个操作发生之前或之后执行，这里给出了after insert，所以此触发器将在insert语句成功执行后执行。

只有表才支持触发器，视图不支持（临时表也不支持）。

触发器按每个表每个事件每次地定义，每个表每个事件每次只允许一个触发器。因此，每个表最多支持6个触发器（每条insert、update和delete的之前和之后）。单一触发器不能与多个事件或多个表关联，所以，如果你需要一个对insert和update操作执行的触发器，则应该定义两个触发器。

如果before触发器失败，则MySQL将不执行请求的操作。此外，如果before触发器或语句本身失败，MySQL将不执行after触发器（如果有的话）。
 <hr style=" border:solid; width:100px; height:1px;" color=#000000 size=1">
 
# 3. 删除触发器
删除触发器，可使用drop trigger语句。

![在这里插入图片描述](https://img-blog.csdnimg.cn/2020100615341077.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80OTk4NDA0NA==,size_16,color_FFFFFF,t_70#pic_center)
触发器不能更新或覆盖。为了修改一个触发器，必须先删除它，然后再重新创建。
<hr style=" border:solid; width:100px; height:1px;" color=#000000 size=1">

# 4. 使用触发器
## 4.1 insert 触发器
insert触发器在insert语句执行之前或之后执行。以下几点需要注意：

 - 在insert触发器代码内，可引用一个名为new的虚拟表，访问被插入的行；
 - 在before insert触发器中，new中的值也可以被更新（允许更改被插入的值）；
 - 对于auto_increment列，new在insert执行之前包含0，在insert执行之后包含新的自动生成值。
 
![在这里插入图片描述](https://img-blog.csdnimg.cn/20201006161215423.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80OTk4NDA0NA==,size_16,color_FFFFFF,t_70#pic_center)
此代码创建一个名为neworder的触发器，它按照after insert on orders执行。在插入一个新订单到orders表时，MySQL生成一个新订单号并保存到order_num中。触发器从New. order_num取得这个值并返回它。此触发器必须按照after insert执行，因为在before insert语句执行之前，新order_num还没有生成。对于orders的每次插入使用这个触发器将总是返回新的订单号。

![在这里插入图片描述](https://img-blog.csdnimg.cn/20201006161806721.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80OTk4NDA0NA==,size_16,color_FFFFFF,t_70#pic_center)

orders 包含3 个列。order_date 和cust_id 必须给出，order_num由MySQL自动生成，而现在order_num还自动被返回。

![在这里插入图片描述](https://img-blog.csdnimg.cn/20201006162110307.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80OTk4NDA0NA==,size_16,color_FFFFFF,t_70#pic_center)

什么时候用before或者after？通常，将before用于数据验证和净化（目的是保证插入表中的数据确实是需要的数据）。
<hr style=" border:solid; width:100px; height:1px;" color=#000000 size=1">

## 4.2 delete 触发器
delete触发器在delete语句执行之前或之后执行。需要注意以下两点：

 - 在delete触发器代码内，你可以引用一个名为old的虚拟表，访问被删除的行；
 - old中的值全都是只读的，不能更新。
 
 ![在这里插入图片描述](https://img-blog.csdnimg.cn/20201006164201411.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80OTk4NDA0NA==,size_16,color_FFFFFF,t_70#pic_center)

在任意订单被删除前将执行此触发器。它使用一条insert语句将old中的值（要被删除的订单）保存到一个名为archive_orders的存档表中（为实际使用这个例子，你需要用与orders相同的列创建一个名为archive_orders的表）。

使用before delete触发器的优点（相对于after delete触发器来说）为，如果由于某种原因，订单不能存档，delete本身将被放弃。

触发器deleteorder使用BEGIN和END语句标记触发器体。这在此例子中并不是必需的，不过也没有害处。使用BEGIN END块的好处是触发器能容纳多条SQL语句（在BEGIN END块中一条挨着一条）。
<hr style=" border:solid; width:100px; height:1px;" color=#000000 size=1">

## 4.3 update 触发器
update触发器在update语句执行之前或之后执行。以下几点需要注意：

 - 在update触发器代码中，你可以引用一个名为old的虚拟表访问以前（update语句前）的值，引用一个名为new的虚拟表访问新更新的值；
 - 在before update触发器中，new中的值可能也被更新（允许更改将要用于update语句中的值）；
 - old中的值全都是只读的，不能更新。
 
 ![在这里插入图片描述](https://img-blog.csdnimg.cn/20201007101928150.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80OTk4NDA0NA==,size_16,color_FFFFFF,t_70#pic_center)
任何数据净化都需要在update语句之前进行。在这个例子中，每次更新一个行时，new.vend_state中的值（将用来更新表行的值）都用Upper(new.vend_state)替换。
<hr style=" border:solid; width:100px; height:1px;" color=#000000 size=1">

## 4.4 关于触发器的进一步介绍
使用触发器需要记住的重点：

 - 创建触发器可能需要特殊的安全访问权限，但是，触发器的执行是自动的。如果insert、update或delete语句能够执行，则相关的触发器也能执行。
 - 应该用触发器来保证数据的一致性（大小写、格式等）。在触发器中执行这种类型的处理的优点是它总是进行这种处理，而且是透明地进行，与客户机应用无关。
 - 触发器的一种非常有意义的使用是创建审计跟踪。使用触发器，把更改（如果需要，甚至还有之前和之后的状态）记录到另一个表非常容易。
 - 遗憾的是，MySQL触发器中不支持CALL语句。这表示不能从触发器内调用存储过程。所需的存储过程代码需要复制到触发器内。
<hr style=" border:solid; width:100px; height:1px;" color=#000000 size=1">

```sql
-- 创建名为newproduct的新触发器
CREATE TRIGGER newproduct AFTER INSERT ON products FOR EACH ROW SELECT 'Product added' INTO @asd;

-- 还没插入操作，所以显示没有值
SELECT @asd;

-- 在products表插入一行数据
INSERT INTO products(prod_id, 
vend_id,
 prod_name, 
 prod_price, 
 prod_desc) 
 VALUES ('AB',
 '1003',
 'Helen',
 '11.11',
 'tomato(1 kilo');
 
 -- 插入数据后有结果显示
SELECT @asd;

-- 删除触发器
DROP TRIGGER newproduct;

-- insert触发器
CREATE TRIGGER neworder AFTER INSERT ON orders 
FOR EACH ROW SELECT New.order_num INTO @asd;

-- 插入新的一行数据到orders中
INSERT INTO orders(order_date,cust_id)
VALUES(NOW(),10001);

-- 显示插入数据后的结果
SELECT @asd;

-- 用OLD保存将要被删除的行到一个存档表中
DELIMITER //
CREATE TRIGGER deleteorder BEFORE DELETE ON orders
FOR EACH ROW 
BEGIN
   INSERT INTO archive_orders(order_num, order_date,cust_id)
   VALUES (old.order_num,old.order_date,old.cust_id);
END//

-- 保证州名缩写总是大写
CREATE TRIGGER updatevendor BEFORE UPDATE ON vendors
FOR EACH ROW SET New.vend_state = UPPER(new.vend_state);

```


