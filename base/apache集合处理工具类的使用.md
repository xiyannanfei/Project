常用的集合工具类主要包括以下几个:CollectionUtils、Arrays、ListUtils、SetUtils、MapUtils五个

#### 1、CollectionUtils的常用方法
* isEmpty():判断集合是否为空
```java
例1: 判断集合是否为空:
CollectionUtils.isEmpty(null): true
CollectionUtils.isEmpty(new ArrayList()): true
CollectionUtils.isEmpty({a,b}): false
```

* isNotEmpty():判断集合不为空

```java
例2: 判断集合是否不为空:
CollectionUtils.isNotEmpty(null): false
CollectionUtils.isNotEmpty(new ArrayList()): false
CollectionUtils.isNotEmpty({a,b}): true
```

* union():取两个集合的并集

```java
例3: 取两个集合的并集
@Test
public void testUnion(){
    String[] arrayA = new String[] { "A", "B", "C", "D", "E", "F" };  
    String[] arrayB = new String[] { "B", "D", "F", "G", "H", "K" };
    List<String> listA = Arrays.asList(arrayA);
    List<String> listB = Arrays.asList(arrayB);
    //2个数组取并集 
    System.out.println(ArrayUtils.toString(CollectionUtils.union(listA, listB)));
    //[A, B, C, D, E, F, G, H, K]
}
```

* intersection():取两个集合的交集

```java
例4: 取两个集合的交集
@Test
public void testIntersection(){
    String[] arrayA = new String[] { "A", "B", "C", "D", "E", "F" };  
    String[] arrayB = new String[] { "B", "D", "F", "G", "H", "K" };
    List<String> listA = Arrays.asList(arrayA);
    List<String> listB = Arrays.asList(arrayB);
    //2个数组取交集 
    System.out.println(ArrayUtils.toString(CollectionUtils.intersection(listA, listB)));
    //[B, D, F]

}
```
* disjunction():取两集合交集的补集(析取)

```java
例5:取交集的补集
@Test
public void testDisjunction(){
    String[] arrayA = new String[] { "A", "B", "C", "D", "E", "F" };  
    String[] arrayB = new String[] { "B", "D", "F", "G", "H", "K" };
    List<String> listA = Arrays.asList(arrayA);
    List<String> listB = Arrays.asList(arrayB);
    //2个数组取交集 的补集
    System.out.println(ArrayUtils.toString(CollectionUtils.disjunction(listA, listB)));
    //[A, C, E, G, H, K]
}
```
* subtract():取两个集合的差集(扣除)

``` java
例6:取两个集合的差集
@Test
public void testSubtract(){
    String[] arrayA = new String[] { "A", "B", "C", "D", "E", "F" };  
    String[] arrayB = new String[] { "B", "D", "F", "G", "H", "K" };
    List<String> listA = Arrays.asList(arrayA);
    List<String> listB = Arrays.asList(arrayB);
    //arrayA扣除arrayB
    System.out.println(ArrayUtils.toString(CollectionUtils.subtract(listA, listB)));
    //[A, C, E]

}
```

* isEqualCollection():判断两个集合是否相等

```java
例7:判断两个集合是否相等
@Test
public void testIsEqual(){

    class Person{}
    class Girl extends Person{
    }
    
    List<Integer> first = new ArrayList<>();
    List<Integer> second = new ArrayList<>();
    first.add(1);
    first.add(2);
    second.add(2);
    second.add(1);
    Girl goldGirl = new Girl();
    List<Person> boy1 = new ArrayList<>();
    //每个男孩心里都装着一个女孩
    boy1.add(new Girl());
    List<Person> boy2 = new ArrayList<>();
    //每个男孩心里都装着一个女孩
    boy2.add(new Girl());
    //比较两集合值
    System.out.println(CollectionUtils.isEqualCollection(first,second));   //true
    System.out.println(CollectionUtils.isEqualCollection(first,boy1));   //false
    System.out.println(CollectionUtils.isEqualCollection(boy1,boy2));   //false
    
    List<Person> boy3 = new ArrayList<>();
    //每个男孩心里都装着一个女孩
    boy3.add(goldGirl);
    List<Person> boy4 = new ArrayList<>();
    boy4.add(goldGirl);
    System.out.println(CollectionUtils.isEqualCollection(boy3,boy4));   //true
}
```
* unmodifiableCollection():得到不可修改的集合

```
例8:得到不可修改的集合
@Test
public void testUnmodifiableCollection(){
    Collection<String> c = new ArrayList<>();
    c.add("张三")
    // 得到不可修改的集合s
    Collection<String> s = CollectionUtils.unmodifiableCollection(c);
    System.out.println(s);// 张三
    // 对集合c进行操作,集合s不发生变化
    c.add("boy");
    c.add("love");
    c.add("girl");
    System.out.println(s);// 张三
    // 对集合s进行操作
    // s.add("have a error");  
}
```
#### 注意事项:Collections.unmodifiableCollection可以得到一个集合的镜像，它的返回结果是不可直接被改变，否则会提示错误

```java
java.lang.UnsupportedOperationException
at org.apache.commons.collections.collection.UnmodifiableCollection.add(UnmodifiableCollection.java:75)
```
* 排序相关的方法:reverse()、shuffle()、sort()、swap()、rotate()等

```java
例9:排序相关的方法
@Test
public void testSort(){

ArrayList list = new ArrayList();
        list.add(3);
        list.add(-2);
        list.add(9);
        list.add(5);
        list.add(-1);
        list.add(6);
        //输出：[3, -2, 9, 5, -1, 6]
        System.out.println(list);
        //集合元素的次序反转
        Collections.reverse(list);
        //输出：[6, -1, 5, 9, -2, 3]
        System.out.println(list);
        
        //排序：按照升序排序
        Collections.sort(list);
        //[-2, -1, 3, 5, 6, 9]
        System.out.println(list);
        
        //根据下标进行交换
        Collections.swap(list, 2, 5);
        //输出：[-2, -1, 9, 5, 6, 3]
        System.out.println(list);
        
        /*//随机排序
        Collections.shuffle(list);
        //每次输出的次序不固定
        System.out.println(list);*/
        
        //后两个整体移动到前边
        Collections.rotate(list, 2);
        //输出：[6, 9, -2, -1, 3, 5]
        System.out.println(list);
    }
}
```

#### 2、Arrays常用的方法

* asList():将数组转成List的方法

```java
例10:将数组转成List的方法
@Test
public void testAsList(){
  String[] array = new String[]{"a","c","2","1","b"};
  Integer[] ints = new Integer[]{5,1,4,3,2};
  List<String> lists = Arrays.asList(array);
  List<Integer> lints = Arrays.asList(ints);
  System.out.println(lists);// [a, c, 2, 1, b]
  System.out.println(lints);// [5, 1, 4, 3, 2]
  // 注:通过Arrays.asList()方法得到的是List集合的一个内部类,它没有add()跟remove()方法!
}
```

* sort():对集合中的元素进行排序

```java
例11:对集合元素进行排序
@Test
public void testAsList(){
  String[] array = new String[]{"a","c","2","1","b"};
  Integer[] ints = new Integer[]{5,1,4,3,2};
  List<String> lists = Arrays.asList(array);
  List<Integer> lints = Arrays.asList(ints);
  // 对集合进行排序
  Arrays.sort(array);
  System.out.println(lists);// [1,2,a,b,c]
  // 按升序对指定范围对数组进行排序fromIndex--->toIndex
  Arrays.sort(ints,2,5);
  System.out.println(lints);// [5,1,2,3,4]
}
```

* copyOf():拷贝数组

```java
  例12:对集合元素进行排序
  @Test
  public void testAsList(){
    String[] array = new String[]{"a","c","2","1","b"};
    Integer[] ints = new Integer[]{5,1,4,3,2};
    List<String> lists = Arrays.asList(array);
    List<Integer> lints = Arrays.asList(ints);
  	//如果位数不够，需要补位
    Integer[] result = Arrays.copyOf(ints,10);
    for(int i=0;i<result.length;i++){
      System.out.print(result[i]+" ");// 5 1 4 3 2 null null null null null
    }
    System.out.println(); 
    //如果位数够，就取最小的数组
    result = Arrays.copyOf(ints,3);
    for(int i : result){
      System.out.print(i+" ");// 5 1 4 
    }
    
    System.out.println();
    result = Arrays.copyOfRange(ints,2,4);
    for(int i : result){
      System.out.print(i+" ");// 4 3
    }
  }
```

* equals():比较数组是否相等

```java
  例13:比较两个数组是否相等
  @Test
  public void testAsList(){
    String[] array = new String[]{"a","c","2","1","b"};
    String[] array2 = new String[]{"a","c","2","1","b"};
    //1 对比引用是否相同
    //2 对比是否存在null
    //3 对比长度是否相同
    //4 挨个元素对比
    System.out.println(Arrays.equals(array,array2));//true
  }
```
