#### 一、导读

　　反射的概念是由Smith在1982年首次提出的，主要是指程序可以访问、检测和修改它本身状态或行为的一种能力。这一概念的提出很快引发了计算机科学领域关于应用反射性的研究。它首先被程序语言的设计领域所采用，并在Lisp和面向对象方面取得了成绩。

　　在计算机科学领域，反射是指一类应用，它们能够自描述和自控制。也就是说，这类应用通过采用某种机制来实现对自己行为的描述（self-representation）和监测（examination），并能根据自身行为的状态和结果，调整或修改应用所描述行为的状态和相关的语义。

　　概念很模糊，刚开始我们也没必要深究。

#### 二、对象的创建

　　“万物皆对象”。对于面向对象语言，我们的操作都要基于对象，所以对象到底是怎么创建来的呢？为了方便说明，我以下面的自定义Person类来进行说明。

```java
package bean;

public class Person {
    private String name;
    private int age;
    public Person(){
        super();
    }
    public Person(String name,int age){
        super();
        this.name = name;
        this.age = age;
    }
    public String getName() {
        return name;
    }
    public void setName(String name) {
        this.name = name;
    }
    public int getAge() {
        return age;
    }
    public void setAge(int age) {
        this.age = age;
    }
    
    public static void function1(){
        System.out.println("function1");
    }
    public void function2(){
        System.out.println("function2");
    }
    public void function3(String s,int i){
        System.out.println(s+":::"+i);
    }
    @SuppressWarnings("unused")
    private void function4(){
        System.out.println("function4");
    }
}
```
　　回到上面的问题：对象的创建，当然很简单：

```java
Person p1 = new Person();
Person p2 = new Person("Lisi",20);
```

　　这样我们就得到了p1和p2两个对象。这是我们最常用也最简单的对象创建方法：使用关键字new。但这种方法仅在开发的时候管用，考虑这样的情况：当我们的程序开发完成之后，我们突然需要使用到某个类对程序进行功能扩展(就是辣么突然哈)，这个时候我们无法再使用new，因为我们的程序已经封装好了，即不能再修改源程序的情况下进行功能扩展，那么我们需要在开发的时候就考虑到这个问题，我们开发的时候就需要对外暴露接口，而我们只需知道被使用来扩展功能的类的类名就可以进行操作了，如何实现呢？（看完可能你有句“什么玩意儿”不知当讲不当讲）。没看懂没关系，现在你只需要知道除了使用new关键字来创建对象外，下面的方法也可以实现对象的创建：（也就是我们要讲的java反射）

```java
//1、获取Class对象
String className = "bean.Person";
Class<?> c = Class.forName(className);
        
//2、使用Class对象创建该类对象：
Object obj = c.newInstance();
```

解析：

　　我们关键字new类创建对象其实内部在进行：1、查找并加载Person.class文件进内存，并将该文件封装成Class字节码文件；2、根据Class字节码文件进行类的创建；3、调用构造函数来初始化对象。

　　而这些步骤便是使用下面两个步骤来完成的：首先使用Class类的forName()来获取Class字节码文件，然后使用Class字节码文件实例化该类，即调用Instance()方法，而调用该方法后会自动调用构造函数进行初始化，完成对象的创建。

　　总结来说就是Person p = new Person();等价于Class.forName("bean.Person").newInstance();

　　一些细节问题：

　　1、forName()方法中传入的是类的名字：Person，但是我们需要在类名前写上包名，bean.Person。因为不同包中可能有相同的类名，我们需要指明包才能找到类。

　　2、 如果指定的类中没有空参数函数或者该类需要指定的构造函数进行初始化时，即我们需要使用到带有参数的构造函数时，就不能再使用Class对象的newInstance()来创建对象了：我们需要这样来创建对象：
　　
　　这样等价于Person p = new Person(“LiSi”,20);
　　
#### 三、Java"反射包"

　　正如上面讲到的对象的创建，Java专门提供了一个包：Java.lang.reflect，用于完成反射：如通过Class对象来获取类的成员、类中的方法等等。
　　![img](https://github.com/xiyannanfei/Project/tree/master/image/反射/201908062339.png)
  
  
  
  
  
