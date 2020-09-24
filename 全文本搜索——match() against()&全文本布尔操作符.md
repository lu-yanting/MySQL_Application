
# 1. 全文本搜索
两个最常使用的引擎为MyISAM和InnoDB，前者支持全文本搜索，而后者不支持。

通配符和正则表达式存在一些重要的限制：

 1. 性能——通配符和正则表达式匹配通常要求MySQL尝试匹配表中所有行（而且这些搜索极少使用表索引）。因此，由于被搜索行数不断增加，这些搜索可能非常耗时。
 2. 明确控制——使用通配符和正则表达式匹配，很难（而且并不总是能）明确地控制匹配什么和不匹配什么。例如，指定一个词必须匹配，一个词必须不匹配，而一个词仅在第一个词确实匹配的情况下才可以匹配或者才可以不匹配。
 3. 智能化的结果——虽然基于通配符和正则表达式的搜索提供了非常灵活的搜索，但它们都不能提供一种智能化的选择结果的方法。例如，一个特殊词的搜索将会返回包含该词的所有行，而不区分包含单个匹配的行和包含多个匹配的行（按照可能是更好的匹配来排列它们）。类似，一个特殊词的搜索将不会找出不包含该词但包含其他相关词的行。
 
 以上这些限制以及更多的限制都可以用**全文本搜索**来解决。在使用全文本搜索时，MySQL不需要分别查看每个行，不需要分别分析和处理每个词。MySQL创建指定列中各词的一个索引，搜索可以针对这些词进行。这样，MySQL可以快速有效地决定哪些词匹配（哪些行包含它们），哪些词不匹配，它们匹配的频率等。
<hr style=" border:solid; width:100px; height:1px;" color=#000000 size=1">

# 2. 使用全文本搜索
为了进行全文本搜索，必须索引被搜索的列，而且要随着数据的改变不断地重新索引。在对表列进行适当设计后，MySQL会自动进行所有的索引和重新索引。
在索引之后，SELECT可与Match()和Against()一起使用以实际执行搜索。

## 2.1 启用全文本搜索支持
一般在创建表时启用全文本搜索。create table语句接受fulltext子句，它给出被索引列的一个逗号分隔的列表。fulltext索引单个列，也可以指定多个列。
![在这里插入图片描述](https://img-blog.csdnimg.cn/20200923105121468.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80OTk4NDA0NA==,size_16,color_FFFFFF,t_70#pic_center)

不要在导入数据时使用fulltext。应该首先导入所有数据，然
后再修改表，定义fulltext。这样有助于更快地导入数据。
<hr style=" border:solid; width:100px; height:1px;" color=#000000 size=1">

## 2.2 进行全文本搜索
在索引之后，使用两个函数Match()和Against()执行全文本搜索，其中Match()指定被搜索的列，Against()指定要使用的搜索表达式。
![在这里插入图片描述](https://img-blog.csdnimg.cn/20200923110756121.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80OTk4NDA0NA==,size_16,color_FFFFFF,t_70#pic_center)
传递给Match() 的值必须与fulltext()定义中的相同。如果指定多个列，则必须列出它们（而且次序正确）。

除非使用binary方式，否则全文本搜索不区分大小写。

用like也可以搜索出结果，但是结果显示的次序不同：
![在这里插入图片描述](https://img-blog.csdnimg.cn/20200923111645109.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80OTk4NDA0NA==,size_16,color_FFFFFF,t_70#pic_center)
上述两条select语句都不包含order by子句。后者（使用like）以不特别有用的顺序返回数据。前者（使用全文本搜索）返回以文本匹配的良好程度排序的数据。两个行都包含词rabbit，但包含词rabbit作为第3个词的行的等级比作为第20个词的行高。这很重要。全文本搜索的一个重要部分就是对结果排序。具有较高等级的行先返回（因为这些行很可能是你真正想要的行）。
此外，由于数据是索引的，全文本搜索还相当快。
<hr style=" border:solid; width:100px; height:1px;" color=#000000 size=1">

## 2.3 使用查询扩展
查询扩展用来设法放宽所返回的全文本搜索结果的范围。
例如，你想找出所有提到anvils的注释。只有一个注释包含词anvils，但你还想找出可能与你的搜索有关的所有其他行，即使它们不包含词anvils。利用查询扩展，能找出可能相关的结果，即使它们并不精确包含所查找的词。

在使用查询扩展时，MySQL对数据和索引进行两遍扫描来完成搜索：

 1. 首先，进行一个基本的全文本搜索，找出与搜索条件匹配的所有行；
 2. 其次，MySQL检查这些匹配行并选择所有有用的词（我们将会简要地解释MySQL如何断定什么有用，什么无用）。
 3. 再其次，MySQL再次进行全文本搜索，这次不仅使用原来的条件，而且还使用所有有用的词。

![在这里插入图片描述](https://img-blog.csdnimg.cn/2020092314364980.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80OTk4NDA0NA==,size_16,color_FFFFFF,t_70#pic_center)
![在这里插入图片描述](https://img-blog.csdnimg.cn/20200923144025559.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80OTk4NDA0NA==,size_16,color_FFFFFF,t_70#pic_center)
第一行包含词anvils，因此等级最高。第二行与anvils无关，但因为它包含第一行中的两个词（customer和recommend），所以也被检索出来。后面几行也是同理。
查询扩展极大地增加了返回的行数，但这样做也增加了你实际上并不想要的行的数目。
表中的行越多（这些行中的文本就越多），使用查询扩展返回的结果越好。
<hr style=" border:solid; width:100px; height:1px;" color=#000000 size=1">

## 2.4 布尔文本搜索
布尔方式，可以提供如下内容的细节：

 1. 要匹配的词；
 2. 要排斥的词（如果某行包含这个词，则不返回该行，即使它包含其他指定的词也是如此）；
 3. 排列提示（指定某些词比其他词更重要，更重要的词等级更高）
 4. 表达式分组；
 
 布尔方式不同于迄今为止使用的全文本搜索语法的地方在于， 即使没有定义fulltext索引，也可以使用它。但这是一种非常缓慢的操作（其性能将随着数据量的增加而降低）。
 ![在这里插入图片描述](https://img-blog.csdnimg.cn/20200924095440325.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80OTk4NDA0NA==,size_16,color_FFFFFF,t_70#pic_center)

![在这里插入图片描述](https://img-blog.csdnimg.cn/20200924095809387.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80OTk4NDA0NA==,size_16,color_FFFFFF,t_70#pic_center)
全文本布尔操作符如下：
![在这里插入图片描述](https://img-blog.csdnimg.cn/20200924095936756.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80OTk4NDA0NA==,size_16,color_FFFFFF,t_70#pic_center)
举例子说明全文本布尔操作符的使用：
![在这里插入图片描述](https://img-blog.csdnimg.cn/20200924100549856.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80OTk4NDA0NA==,size_16,color_FFFFFF,t_70#pic_center)
![在这里插入图片描述](https://img-blog.csdnimg.cn/20200924100744334.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80OTk4NDA0NA==,size_16,color_FFFFFF,t_70#pic_center)
![在这里插入图片描述](https://img-blog.csdnimg.cn/20200924101107276.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80OTk4NDA0NA==,size_16,color_FFFFFF,t_70#pic_center)
![在这里插入图片描述](https://img-blog.csdnimg.cn/20200924101231708.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80OTk4NDA0NA==,size_16,color_FFFFFF,t_70#pic_center)
![在这里插入图片描述](https://img-blog.csdnimg.cn/20200924101422649.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80OTk4NDA0NA==,size_16,color_FFFFFF,t_70#pic_center)
<hr style=" border:solid; width:100px; height:1px;" color=#000000 size=1">

## 2.5 全文本搜索的使用说明

 1. 在索引全文本数据时，短词被忽略且从索引中排除。短词定义为那些具有3个或3个以下字符的词。
 2. MySQL带有一个内建的非用词（stopword）列表，这些词在索引全文本数据时总是被忽略。如果需要，可以覆盖这个列表。
 3. 许多词出现的频率很高，搜索它们没有用处（返回太多的结果）。因此，MySQL规定了一条50%规则，如果一个词出现在50%以上的行中，则将它作为一个非用词忽略。50%规则不用于IN BOOLEANMODE。
 4. 如果表中的行数少于3行，则全文本搜索不返回结果（因为每个词或者不出现，或者至少出现在50%的行中）。
 5. 忽略词中的单引号。例如，don't索引为dont。
 6. 不具有词分隔符（包括日语和汉语）的语言不能恰当地返回全文本搜索结果。
 7. 仅在MyISAM数据库引擎中支持全文本搜索。
 <hr style=" border:solid; width:100px; height:1px;" color=#000000 size=1">

```sql
-- fulltext()
CREATE TABLE mydatabase.productnotes
(
  note_id INT             NOT NULL AUTO_INCREMENT,
  prod_id CHAR(10)        NOT NULL,
  note_date DATETIME      NOT NULL,
  note_text TEXT          NULL,
  PRIMARY KEY(note_id),
  FULLTEXT(note_text)
 ) ENGINE=MYISAM;
 
 -- 使用函数match()和aganist()
 SELECT note_text 
 FROM productnotes
 WHERE MATCH(note_text) AGAINST('rabbit');
 
 -- 用like检索，结果显示的次序不同
 SELECT note_text 
 FROM productnotes
 WHERE note_text LIKE '%rabbit%';
 
 -- 演示排序如何工作
 SELECT note_text, MATCH(note_text) AGAINST('rabbit') AS rank
 FROM productnotes;
 
 -- 简单的全文本搜索，没有查询扩展
 SELECT note_text 
 FROM productnotes
 WHERE MATCH(note_text) AGAINST('anvils');
 
 -- 使用查询扩展
 SELECT note_text 
 FROM productnotes
 WHERE MATCH(note_text) AGAINST('anvils' WITH QUERY EXPANSION);
 
 -- 2020-09-24  9:29
 USE lu_test;
 
 -- in boolean mode
 SELECT note_text 
 FROM productnotes 
 WHERE MATCH(note_text) AGAINST('heavy' IN BOOLEAN MODE);
 
 -- 匹配包含heavy但不包含任意以rope开始的词的行
 SELECT note_text 
 FROM productnotes 
 WHERE MATCH(note_text) AGAINST('heavy -rope*' IN BOOLEAN MODE);
 
 -- 匹配包含词rabbit和bait的行
 SELECT note_text 
 FROM productnotes 
 WHERE MATCH(note_text) AGAINST('+rabbit +bait' IN BOOLEAN MODE);
 
 -- 匹配包含rabbit和bait中的至少一个词的行
 SELECT note_text 
 FROM productnotes 
 WHERE MATCH(note_text) AGAINST('rabbit bait' IN BOOLEAN MODE);
 
 -- 匹配短语rabbit bait而不是匹配两个词rabbit和bait。
 SELECT note_text 
 FROM productnotes 
 WHERE MATCH(note_text) AGAINST('''rabbit bait''' IN BOOLEAN MODE);
 
 -- 匹配rabbit和carrot，增加前者的等级，降低后者的等级
 SELECT note_text 
 FROM productnotes 
 WHERE MATCH(note_text) AGAINST('>rabbit <carrot' IN BOOLEAN MODE);
 
 -- 匹配词safe和combination，降低后者的等级
 SELECT note_text 
 FROM productnotes 
 WHERE MATCH(note_text) AGAINST('+safe +(<combination)' IN BOOLEAN MODE);
```

 

