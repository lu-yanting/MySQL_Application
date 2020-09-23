
# 1.组合查询
组合查询指的是：在Mysql中执行多个查询，并将结果作为单个查询结果集返回。
这些组合查询通常称为并或复合查询。

以下2种情况，需要使用组合查询：

 1. 在单个查询中从不同的表返回类似结构的数据；
 2. 对单个表执行多个查询，按单个查询返回数据。
 <hr style=" border:solid; width:100px; height:1px;" color=#000000 size=1">
 
# 2.创建组合查询
可用union操作符来组合数条SQL查询。利用union，可给出多条select语句，将它们的结果组合成单个结果集。

## 2.1 使用union
union的使用方法：给出每条select语句，在各条语
句之间放上关键字union。
union指示MySQL执行多条select语句，并把输出组
合成单个查询结果集。
![在这里插入图片描述](https://img-blog.csdnimg.cn/20200923092404471.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80OTk4NDA0NA==,size_16,color_FFFFFF,t_70#pic_center)
在这个简单的例子中，使用union可能比使用where子句更为复杂。但对于更复杂的过滤条件，或者从多个表（而不是单个表）中检索数据的情形，使用union可能会使处理更简单。
<hr style=" border:solid; width:100px; height:1px;" color=#000000 size=1">

## 2.2 union规则

 1. union必须由两条或两条以上的select语句组成，语句之间用关键字union分隔（因此，如果组合4条select语句，将要使用3个union关键字）。
 2. union中的每个查询必须包含相同的列、表达式或聚集函数（不过各个列不需要以相同的次序列出）。
 3. 列数据类型必须兼容：类型不必完全相同，但必须是DBMS可以隐含地转换的类型（例如，不同的数值类型或不同的日期类型）。
<hr style=" border:solid; width:100px; height:1px;" color=#000000 size=1"> 

## 2.3 包含或取消重复的行
在使用union时，重复的行被自动取消。
这是union的默认行为，但是如果需要，可以改变它。事实上，如果想返回所有匹配行，可使用union all而不是union。
![在这里插入图片描述](https://img-blog.csdnimg.cn/20200923093939418.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80OTk4NDA0NA==,size_16,color_FFFFFF,t_70#pic_center)
union几乎总是完成与多个where条件相同的工作。union all为union的一种形式，它完成where子句完成不了的工作。如果确实需要每个条件的匹配行全部出现（包括重复行），则必须使用union all而不是where。
<hr style=" border:solid; width:100px; height:1px;" color=#000000 size=1">

## 2.4 对组合查询结果排序
在用union组合查询时，只能使用一条order by子句，它必须出现在最后一条select语句之后。虽然order by子句似乎只是最后一条select语句的组成部分，但实际上MySQL将用它来排序所有select语句返回的所有结果。
![在这里插入图片描述](https://img-blog.csdnimg.cn/20200923094917743.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80OTk4NDA0NA==,size_16,color_FFFFFF,t_70#pic_center)
<hr style=" border:solid; width:100px; height:1px;" color=#000000 size=1">

```sql
-- 使用union
-- 第一条select语句，检索价格不高于5的所有物品
SELECT vend_id, prod_id, prod_price 
FROM products 
WHERE prod_price <= 5;
-- 第二条select语句，检索包括供应商1001、1002生产的所有物品
SELECT vend_id, prod_id, prod_price 
FROM products 
WHERE vend_id IN (1001,1002);
-- 用union将2条select语句组合起来
SELECT vend_id, prod_id, prod_price 
FROM products 
WHERE prod_price <= 5 
UNION 
SELECT vend_id, prod_id, prod_price 
FROM products 
WHERE vend_id IN (1001,1002);

-- union all，显示包括重复的行
SELECT vend_id, prod_id, prod_price 
FROM products 
WHERE prod_price <= 5 
UNION ALL
SELECT vend_id, prod_id, prod_price 
FROM products 
WHERE vend_id IN (1001,1002);

-- 在union中，使用order by排序
SELECT vend_id, prod_id, prod_price 
FROM products 
WHERE prod_price <= 5 
UNION 
SELECT vend_id, prod_id, prod_price 
FROM products 
WHERE vend_id IN (1001,1002)
ORDER BY vend_id, prod_price;
```

