由于jdk1.7中将字符串常量池改为存放在堆中，因此intern()方法的实现原理相对以前的版本也有所改变。

我们根据jdk的版本来进行一些分析：

### jdk1.6中字符串常量池存放在永久代中：

* 当使用intern()方法时，查询字符串常量池是否存在当前字符串，若不存在则将当前字符串复制到字符串常量池中，并返回字符串常量池中的引用。

### jdk1.7中字符串常量池存放在堆中：

* 当使用intern()方法时，先查询字符串常量池是否存在当前字符串，若字符串常量池中不存在则再从堆中查询，然后存储并返回相关引用；

* 若都不存在则将当前字符串复制到字符串常量池中，并返回字符串常量池中的引用。

### 从上面叙述中，可以得出其中的区别：

* jdk1.6中只能查询或创建在字符串常量池；

* jdk1.7中会先查询字符串常量池，若没有又会到堆中再去查询并存储堆的引用，然后返回。

### 验证以上观点：　

```
String s = new String("1") + new String("2");
System.out.println(s.intern() == s);
```

* jdk1.6中输出结果为 false

  ​解释：s.intern()查询字符串常量池中是否存在“12”后，将“12”复制到字符串常量池中并返回字符串常量池的引用。而s存放在在堆中，返回false。

* jdk1.7中输出结果为 true

  ​解释：s.intern()先查询字符串常量池中是否存在“12”后，再从堆中查询“12”是否存在并存储堆中的引用并返回。因此s.intern()与s指向的是同一个引用，返回
  
   true。

借用美团技术团队《深入解析String#intern》一文中两段代码与相关图片来进行解释：

注：图中绿色线条代表 string 对象的内容指向。 黑色线条代表地址指向。

第一段代码：

```
String s = new String("1");
s.intern();
String s2 = "1";
System.out.println(s == s2);

String s3 = new String("1") + new String("1");
s3.intern();
String s4 = "11";
System.out.println(s3 == s4);
```

* jdk1.6中输出结果为 false false

  解释：
  
  String s = new String("1"); 在字符串常量池中创建"1"对象，在堆中创建s对象。
  
  s.intern(); 由于字符串常量池中已经有"1"对象，因此该句并无实际意义。
  
  s2指向字符串常量池中"1"对象。因此s指向堆中的引用，s2指向字符串常量池中的引用，返回 false。

  String s3 = new String("1") + new String("1"); 在堆中创建s3对象。
  
  s3.intern(); 将字符串"11"复制到字符串常量池中。
  
  s4指向字符串常量池中"11"对象。

  因此s3指向堆中的引用，s4指向字符串常量池中的引用，返回 false。

  ![img](https://img2018.cnblogs.com/blog/1399084/201903/1399084-20190316140611047-2128507065.png)

* jdk1.7中输出结果为 false true

  解释：

  s与s2的情况与jdk1.6中一样，返回 false。

  s3与s4有所不同的是s3.intern(); 先在字符串常量池中查找是否存在"11"，再从堆中查找，

  然后将堆中s3的引用存储到字符串常量池中。

  String s4 = "11"; 创建的时候发现字符串常量池中有了“11”（s3），然后指向s3引用的对象。

  因此s3与s4的引用相同，返回 true。

  ![img](https://img2018.cnblogs.com/blog/1399084/201903/1399084-20190316140635659-1582684768.png)

第二段代码：

```
String s = new String("1");
String s2 = "1";
s.intern();
System.out.println(s == s2);

String s3 = new String("1") + new String("1");
String s4 = "11";
s3.intern();
System.out.println(s3 == s4);
```

* jdk1.6中输出结果为 false false

  解释：

  与上一段代码中s与s2的情况一样，返回false。

  与上一段代码中s3与s4的情况大概一样，只是String s4 = "11"; 先在字符串常量池中创建"11"对象。

  s3.intern(); 并无实际意义。

  因此s3指向堆中的引用，s4指向字符串常量池中的引用，返回 false。

* jdk1.7中输出结果为 false false

  解释：

  与上一段代码中s与s2的情况一样，返回false。

  与jdk1.6中s3与s4的情况一样。

  ![img](https://img2018.cnblogs.com/blog/1399084/201903/1399084-20190316140651335-411801566.png)

### 总结：

*  jdk1.6的环境下使用intern()方法后，String对象只会引用或创建在字符串常量池中的对象。
*  jdk1,7的环境下使用intern()方法后，String对象需要注意所引用的是字符串常量池中的还是堆中的对象。

#### 然后intern()方法的作用上，用一句话概括的话就是：intern()方法设计的初衷就是为了重用String对象，以节省内存消耗。

下面参考给出的链接中有详细的讲解，有兴趣的朋友可以去看看，这里就不重复叙述了。

参考：美团技术团队《深入解析String#intern》 [https://tech.meituan.com/in_depth_understanding_string_intern.html](https://tech.meituan.com/in_depth_understanding_string_intern.html)
