常用的集合工具类主要包括以下几个:CollectionUtils、ListUtils、SetUtils、MapUtils四个

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
