### 首先，该方法是将数组转化为list。有以下几点需要注意：

* 该方法不适用于基本数据类型（byte,short,int,long,float,double,boolean）

* 该方法将数组与列表链接起来,当更新其中之一时,另一个自动更新

* 不支持add和remove方法

####  一、java.util.Arrays.asList() 的一般用法

List 是一种很有用的数据结构,如果需要将一个数组转换为 List 以便进行更丰富的操作的话,可以这么实现：

```java
    String[] myArray = { "Apple", "Banana", "Orange" }； 
    List<String> myList = Arrays.asList(myArray);
```
或者
```java
    List<String> myList = Arrays.asList("Apple", "Orange");
```
上面这两种形式都是十分常见的:将需要转化的数组作为参数,或者直接把数组元素作为参数,都可以实现转换。

####  二、极易出现的错误及相应的解决方案

####  错误一: 将原生数据类型数据的数组作为参数

前面说过，可以将需要转换的数组作为 asList 方法的参数。假设现在需要转换一个整型数组，那可能有人会想当然地这么做：

```java
public class Test {
   public static void main(String[] args) {
      int[] myArray = { 1, 2, 3 };
      List myList = Arrays.asList(myArray);
      System.out.println(myList.size());
   }
}
```

上面这段代码的输出结果是什么,会是3吗？如果有人自然而然地写出上面这段代码的话,那么他也一定会以为 myList 的大小为3。很遗憾,这段代码的输出结果不是3,而是1。如果尝试遍历 myList,你会发现得到的元素不是1、2、3中的任意一个,而是一个带有 hashCode 的对象,为什么会如此？
  
来看一下asList 方法的签名：

```java
public static <T> List<T> asList(T... a)

```

注意：参数类型是 T ，根据官方文档的描述，T 是数组元素的 **class**。

  如果你对反射技术比较了解的话,那么 class 的含义想必是不言自明。我们知道任何类型的对象都有一个 class 属性,这个属性代表了这个类型本身。原生数据类型,比如 int，short，long等,是没有这个属性的,具有 class 属性的是它们所对应的包装类 Integer，Short，Long。

  因此,这个错误产生的原因可解释为:asList 方法的参数必须是对象或者对象数组,而原生数据类型不是对象——这也正是包装类出现的一个主要原因。当传入一个原生数据类型数组时,asList 的真正得到的参数就不是数组中的元素，而是**数组对象**本身！此时List 的唯一元素就是这个数组。

#### 解决方案:使用包装类数组

  如果需要将一个整型数组转换为 List,那么就将数组的类型声明为 **Integer** 而不是 int。

```java
public class Test {
   public static void main(String[] args) {
      Integer[] myArray = { 1, 2, 3 };
      List myList = Arrays.asList(myArray);
      System.out.println(myList.size());
   }
}
```
  这时 myList 的大小就是3了，遍历的话就得到1、2、3。这种方案是比较简洁明了的。
  
  其实在文章中,作者使用了另一种解决方案:使用了 Java 8 新引入的 API

```java
public class Test {
   public static void main(String[] args) {
      int[] intArray = { 5, 10, 21 };
      //Java 8 新引入的 Stream 操作
      List myList = 			   Arrays.stream(intArray).boxed().collect(Collectors.toList());
   }
}
```

####  错误二:试图修改 List 的大小

  我们知道 List 是可以动态扩容的,因此在创建一个 List 之后最常见的操作就是向其中添加新的元素或是从里面删除已有元素:

```java
public class Test {
   public static void main(String[] args) {
      String[] myArray = { "Apple", "Banana", "Orange" };
      List<String> myList = Arrays.asList(myArray);
      myList.add("Guava");
   }
}
```
  尝试运行这段代码,结果抛出了一个 `java.lang.UnsupportedOperationException` 异常！这一异常意味着,向 myList 添加新元素是不被允许的;如果试图从 myList 中删除元素,也会抛出相同的异常。为什么会如此？
  
  仔细阅读官方文档，你会发现对 asList 方法的描述中有这样一句话:

> 返回一个由指定数组生成的**固定大小**的 List。

  谜底揭晓，用 asList 方法产生的 List 是固定大小的，这也就意味着任何改变其大小的操作都是不允许的。
  
  那么新的问题来了：按道理 List 本就支持动态扩容，那为什么偏偏 asList 方法产生的 List 就是固定大小的呢？如果要回答这一问题，就需要查看相关的源码。Java 8 中 asList 方法的源码如下：

```java
@SafeVarargs
@SuppressWarnings("varargs")
public static <T> List<T> asList(T... a) {
    return new ArrayList<>(a);
}
```
  方法中的的确确生成了一个 ArrayList,这不应该是支持动态扩容的吗？别着急，接着往下看。紧跟在 asList 方法后面,有这样一个内部类:

```java
private static class ArrayList<E> extends AbstractList<E> implements RandomAccess, java.io.Serializable
{
    private static final long serialVersionUID = -2764017481108945198L;
    private final E[] a;

    ArrayList(E[] array) {
        a = Objects.requireNonNull(array);
    }

    @Override
    public int size() {
        return a.length;
    }

    //...
}

```
  这个内部类也叫 ArrayList ，更重要的是在这个内部类中有一个被声明为 **final** 的数组 a ，所有传入的元素都会被保存在这个数组 a 中。到此，谜底又揭晓了： asList 方法返回的确实是一个 ArrayList ,但这个 ArrayList 并不是 java.util.ArrayList ，而是 java.util.Arrays 的一个内部类。这个内部类用一个 final 数组来保存元素，因此用 asList 方法产生的 ArrayList 是不可修改大小的。

####  解决方案:创建一个真正的 ArrayList

  既然我们已经知道之所以asList 方法产生的 ArrayList 不能修改大小，是因为这个 ArrayList 并不是“货真价实”的 ArrayList ，那我们就自行创建一个真正的 ArrayList:

```
public class Test {
   public static void main(String[] args) {
      String[] myArray = { "Apple", "Banana", "Orange" };
      List<String> myList = new ArrayList<String>(Arrays.asList(myArray));
      myList.add("Guava");
   }
}

```

  在上面这段代码中，我们 new 了一个 java.util.ArrayList ，然后再把 asList 方法的返回值作为构造器的参数传入，最后得到的 myList 自然就是可以动态扩容的了。

####  三、用自己的方法实现数组到 List 的转换

  有时，自己实现一个方法要比使用库中的方法好。鉴于 asList 方法有一些限制，那么我们可以用自己的方法来实现数组到 List 的转换：
  
```java
public class Test {
   public static void main(String[] args) {
      String[] myArray = { "Apple", "Banana", "Orange" };
      List<String> myList = new ArrayList<String>();
      for (String str : myArray) {
         myList.add(str);
      }
      System.out.println(myList.size());
   }
}

```
  这么做自然也是可以达到目的的，但显然有一个缺点：代码相对冗长，而且这么做其实无异于自己造轮子（reinventing the wheel）。当然了，自己实现方法的好处也是显而易见的，不管有什么需求，自己来满足就好了，毕竟自己动手丰衣足食嘛。比如说需要把数组的每个元素向 List 中添加两次：

```java
public class Test {
   public static void main(String[] args) {
      String[] myArray = { "Apple", "Banana", "Orange" };
      List<String> myList = new ArrayList<String>();
      for (String str : myArray) {
         myList.add(str);
         myList.add(str);
      }
      System.out.println(myList.size());
   }
}
```

  总之，问题的解决方案往往不止一个，为了效率我们往往会选择使用已有轮子来决解问题，但如果没有任何限制的话不妨试试别的方案。
