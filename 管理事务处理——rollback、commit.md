
# 1. 事务处理
事务处理可以用来维护数据库的完整性，它保证成批的MySQL操作要么完全执行，要么完全不执行。

事务处理是一种机制，用来管理必须成批执行的MySQL操作，以保证数据库不包含不完整的操作结果。利用事务处理，可以保证一组操作不会中途停止，它们或者作为整体执行，或者完全不执行（除非明确指示）。如果没有错误发生，整组语句提交给（写到）数据库表。如果发生错误，则进行回退（撤销）以恢复数据库到某个已知且安全的状态。

事务处理需要知道的几个术语：

 - 事务：指一组SQL语句；
 - 回退：指撤销指定SQL语句的过程；
 - 提交：指将未存储的SQL语句结果写入数据库表；
 - 保留点：指事务处理中设置的临时占位符，你可以对它发布回退（与回退整个事务处理不同）。
<hr style=" border:solid; width:100px; height:1px;" color=#000000 size=1">

# 2. 控制事务处理
管理事务处理的关键在于将SQL语句组分解为逻辑块，并明确规定数据何时应该回退，何时不应该回退。
MySQL使用start transaction语句来标识事务的开始。

## 2.1 使用rollback
MySQL的rollback命令用来回退（撤销）MySQL语句。

![在这里插入图片描述](https://img-blog.csdnimg.cn/20201007162905508.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80OTk4NDA0NA==,size_16,color_FFFFFF,t_70#pic_center)
分析：这个例子从显示productnotes表的内容开始。首先执行一条select以显示该表不为空。然后开始一个事务处理，用一条delete语句删除productnotes中的所有行。另一条select语句验证productnotes确实为空。这时用一条rollback语句回退start transaction之后的所有语句，最后一条select语句显示该表不为空。

rollback只能在一个事务处理内使用（在执行一条start transaction命令之后）。

事务处理用来管理insert、update和delete语句。你不能回退select语句,也不能回退create或drop操作。
<hr style=" border:solid; width:100px; height:1px;" color=#000000 size=1">

## 2.2 使用commit
在事务处理块中，提交不会隐含地进行。为进行明确的提交，使用commit语句。

![在这里插入图片描述](https://img-blog.csdnimg.cn/20201007165409991.png#pic_center)

分析：在这个例子中，从系统中完全删除订单20010。因为涉及更新两个数据库表orders和orderitems，所以使用事务处理块来保证订单不被部分删除。最后的commit语句仅在不出错时写出更改。如果第一条delete起作用，但第二条失败，则delete不会提交（实际上，它是被自动撤销的）。

当commit或rollback语句执行后，事务会自动关闭（将来的更改会隐含提交）。
<hr style=" border:solid; width:100px; height:1px;" color=#000000 size=1">

## 2.3 使用保留点
为了支持回退部分事务处理，必须能在事务处理块中合适的位置放置占位符。这样，如果需要回退，可以回退到某个占位符。

这些占位符称为保留点。为了创建占位符，可如下使用savepoint语句：savepoint deletel;

每个保留点都取标识它的唯一名字，以便在回退时，MySQL知道要回退到何处。为了回退到本例给出的保留点，可如下进行：rollback to deletel;

可以在MySQL代码中设置任意多的保留点，越多越好。为什么呢？因为保留点越多，你就越能按自己的意愿灵活地进行回退。

保留点在事务处理完成（执行一条rollback或commit）后自动释放。自MySQL 5以来，也可以用release savepoint明确地释放保留点。
<hr style=" border:solid; width:100px; height:1px;" color=#000000 size=1">

## 2.4 更改默认的提交行为
默认的MySQL行为是自动提交所有更改，为指示MySQL不自动提交更改，需要使用以下语句：set autocommit=0;

autocommit标志决定是否自动提交更改，不管有没有commit语句。设置autocommit为0（假）指示MySQL不自动提交更改（直到autocommit被设置为真为止）。
<hr style=" border:solid; width:100px; height:1px;" color=#000000 size=1">

```sql
USE mydatabase;
INSERT INTO productnotes(note_id,prod_id,note_date,note_text)
VALUES('1','4','2020-10-07','abc');

-- 使用rollback回退（撤销）
SELECT * FROM productnotes;
START TRANSACTION;
DELETE FROM productnotes;
SELECT * FROM productnotes;
ROLLBACK;
SELECT * FROM productnotes;

-- 用commit进行明确提交
START TRANSACTION;
DELETE FROM orderitems WHERE order_num = 20010;
DELETE FROM orders WHERE order_num = 20010;
COMMIT;

```

