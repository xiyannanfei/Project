replace、replaceAll和replaceFirst是JAVA中常用的替换字符的方法,它们的区别与相同点如下

### 区别点：

1)replace的参数是char和CharSequence，即可以支持字符的替换，也支持字符串的替换(CharSequence即字符串序列的意思,说白了也就是字符串)；

2)replaceAll的参数是regex，即基于规则表达式的替换，比如，可以通过replaceAll("\\d", "*")把一个字符串所有的数字字符都换成星号;

3)replaceFirst只替换第一次出现的，后面就不管了；

### 相同点

都是全部替换，即把源字符串中的某一字符或字符串全部换成指定的字符或字符串，如果只想替换第一次出现的，可以使用replaceFirst()，这个方法也是基于规则表达式的替换，但与replaceAll()不同的是，只替换第一次出现的字符串；

另外，如果replaceAll()和replaceFirst()所用的参数据不是基于规则表达式的，则与replace()替换字符串的效果是一样的，即这两者也支持字符串的操作；



