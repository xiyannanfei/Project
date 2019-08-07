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

　　![img][1]
　　
#### 四、获取类的字段

　　假设现在我们需要访问Person类中的字段：name和age。
　　
　　1、获取：我们可以使用Class对象中的getField()方法和getDeclaredField()来访问，两者的区别在于：getField()返回的是公有的字段和父类中的字段，而getDeclaredField()返回的是私有化的字段。

　　2、使用：我们获取到了字段就可以进行使用了，但在使用之前我们需要知道：1)该类对象  2）使用的字段是否有访问权限。

　　1）使用forName()创建一个对象；

　　2）如果使用的字段无访问权限，即公有，则可以直接使用；如果该字段私有，则我们需要使用setAccessible(true)来取消权限设置，才能进行访问。

　　看具体实现代码：

```java
package reflect;

import java.lang.reflect.Field;

public class getFieldDemo {
    public static void main(String[] args) throws Exception {
        String className = "bean.Person";
        Class<?> c = Class.forName(className);
        
        //获取私有字段
        Field nameField = c.getDeclaredField("name");
        Field ageField = c.getDeclaredField("age");
        
        //使用字段（使用之前我们需要一个该类对象）
        Object obj = c.newInstance();
        
        //使用set()方法设置字段值
        nameField.setAccessible(true);
        ageField.setAccessible(true);//暴力访问
        nameField.set(obj, "张三");
        ageField.set(obj,20);
        
        //打印查看效果
        System.out.println("获取到的字段：");
        System.out.println("name:"+nameField);
        System.out.println("age:"+ageField);
        System.out.println("字段设置的值：name="+nameField.get(obj)+",age="+ageField.get(obj));
    }
}

getFieldDemo
```
打印结果：

![img][2]


#### 五、获取类中的方法

　　假设我们需要获取到Person类中的4个方法： 类似获取字段，我们首先要明确该方法的访问权限和是否有参数。

　　1、获取：我们使用getMethods()和getDeclaredMethods()来获取方法：前者获取公有及父类中的方法，后者获取私有方法。而获取一个方法则使用getMethod(String name,Class<?>... parameterTypes)和getDeclaredMethod(String name,Class<?>... parameterTypes)来获取。

　　2、调用：使用Method类中的invoke(object obj,object args...)方法来调用有参数的方法的底层方法。

具体实现代码：

```java
package reflect;

import java.lang.reflect.Method;

public class getMethodDemo {
    public static void main(String[] args) throws Exception {
        String className = "bean.Person";
        Class<?> c = Class.forName(className);
        
        //获取公共方法：
        Method[] pubMethods = c.getMethods();
        
        //获取私有方法：
        Method[] priMethods = c.getDeclaredMethods();
        
        
        //获取单个方法：按方法名和参数获取
        
        //获取单个の静态方法：function1
        Method staMethod = c.getMethod("function1",null);
        //获取单个の无参数方法：function2
        Method nullMethod = c.getMethod("function2",null);
        //获取单个の有参数方法：function3
        Method moreMethod = c.getMethod("function3",String.class,int.class);
        //获取单个の私有方法：function4
        Method priMethod = c.getDeclaredMethod("function4",null);
        
        //打印查看效果
        System.out.println("[Person类的公共方法及父类方法:]");
        for(Method m:pubMethods){
            System.out.println(m);
        }
        System.out.println("[Person类的私有方法:]");
        for(Method m:priMethods){
            System.out.println(m);
        }
        System.out.println("[按方法名和参数类型获取的方法4个方法:]");
        System.out.println(staMethod);
        System.out.println(nullMethod);
        System.out.println(moreMethod);
        System.out.println(priMethod);    
    }
}
```
打印结果：

![img][3]

```java
package reflect;

import java.lang.reflect.Method;

public class invokeDemo {
    public static void main(String[] args) throws Exception {
        String className = "bean.Person";
        Class<?> c = Class.forName(className);
        
        //获取有参数的方法：function3
        Method moreMethod = c.getDeclaredMethod("function3",String.class,int.class);
        
        //使用之前我们需要创建一个该类对象：
        Object obj = c.newInstance();
        moreMethod.setAccessible(true);//设置访问权限
        Object value = moreMethod.invoke(obj,"李四",20);
        
        //打印查看效果
        System.out.println(value);
    }
}
```
打印结果:

![img][4]

#### 六、进阶：反射机制的运用实例の我的电脑没USB

　　我们以下面这个类：myComputer来说明：

```java
package bean;
/*
 * 模拟一台具有开机关机功能的电脑.
 */
public class myComputer {
    public void run(){
        System.out.println("Running...");
    }
    public void close(){
        System.out.println("Closed!");
    }
}
```

　　现在假设你开发出来了一台电脑：没错就是上面myComputer(唉，别走回来)。

　　假设你开发的这台电脑问世的时候只能开机和关机，现在你觉得这台电脑的功能有一点单调了(一点？)，所以你希望这台电脑可以实现：鼠标和键盘的连接，并可以使用鼠标和键盘的功能。那么要怎么实现呢？

　　我们都知道接鼠标或键盘需要有USB接口才能实现，所以我们需要myComputer具备USB接口功能：我们可以使用接口Interface实现。然后我们需要让USB接口和鼠标或键盘相匹配或者说连接起来：则我们让鼠标和键盘可以实现USB接口。然而问题的关键在于我在开发myComputer时并不知道我有什么鼠标啊键盘啊什么的，更别说拿来用了。该如何让鼠标或键盘等外部设备为我所用呢？

　　现在我们唯一能知道的就是鼠标啊、键盘啊等设备的名字，它们内部是什么都不清楚，怎么创建一个鼠标或键盘对象来调用它们的方法呢？如果你好好看了上面的反射，那么你应该可以实现：我们只需要使用Class.forName(className).newInstance();就行了。我们只需要知道className即类的名字就能创建这个类，包括获取类的字段、类的方法等等关于该类的信息，这就是反射的强大之处。

#### 七、进阶：反射机制的运用实例の我的电脑有USB啦啦啦

　　1、首先我们需要对初代myComputer就行改进：实现USB接口

 myComputer2:

```java
package bean;
/*
 * 模拟一台具有开机关机功能的电脑.
 */
public class myComputer2 {
    public void run(){
        System.out.println("Running...");
    }
    public void close(){
        System.out.println("Closed!");
    }
    //升级后的2代计算机：USB功能
    public void useUSB(USB usb){
        if(usb != null){//如果设备连接上，则开始使用设备功能
            usb.connection();
            usb.close();
        }
    }
}
```

USB接口：

```java
package bean;
/*
 * 用于描述USB接口
 */
public interface USB {
    public void connection();//设备连接
    public void close();//设备断开
}
```

设备：鼠标和键盘

```java
package bean;
/*
 * 鼠标
 */
public class Mouse implements USB {

    @Override
    public void connection() {
        System.out.println("鼠标正在使用...");
    }

    @Override
    public void close() {
        System.out.println("鼠标已断开连接！");
    }

}

```

```java
package bean;
/*
 * 键盘
 */
public class keyboard implements USB {

    @Override
    public void connection() {
        System.out.println("键盘正在使用...");
    }

    @Override
    public void close() {
        System.out.println("键盘已断开连接！");
    }

}
```

2、USB的使用测试：

我们现在来测试一下：

```java
package reflect;

import bean.USB;
import bean.myComputer2;

public class test {
    public static void main(String[] args) throws Exception {
        myComputer2 mc = new myComputer2();
        
        //我们只需要知道封装设备的类名即可
        String className = "bean.Mouse";
        Class<?> c = Class.forName(className);
        Object obj = c.newInstance();
        
        USB usb = (USB)obj;
        mc.useUSB(usb);
    }
}
```

test的测试结果：

![img][5]


很明显，"鼠标"接上myComputer2后可以正常使用。

3、测试改进：

　　对于上面的测试类test中的className的值我们是手动输入的，这不符合后来开发者的需求，因为我们开发的时候可能根本不知道有鼠标这种设备，或者说要是将来有新的设备连接我们该怎么办呢？

　　这时候我们需要使用到配置文件，即使用IO流来对我们使用的设备进行后台管理。

　　看具体改进代码：


```java
package reflect;

import java.io.File;
import java.io.FileInputStream;
import java.util.Properties;

import bean.USB;
import bean.myComputer2;

public class test2 {
    public static void main(String[] args) throws Exception {
        myComputer2 mc = new myComputer2();
        
        //利用IO流，使用配置文件传入类名：
        File config = new File("tempFile\\usb.config");
        FileInputStream fis = new FileInputStream(config);
        Properties prop = new Properties();
        prop.load(fis);
        String className = null;
        className = prop.getProperty("usb");
        
        
        Class<?> c = Class.forName(className);
        Object obj = c.newInstance();
        
        USB usb = (USB)obj;
        mc.useUSB(usb);
    }
}
```

现在我的配置文件传入什么设备，那么这台电脑就会使用什么设备：

如我的配置文件为：

![img][6]

这里我连接的设备是keyboard即键盘，那么运行结果会是什么呢？

![img][7]






[1]:https://github.com/xiyannanfei/Project/blob/master/image/基础篇/201908062339.png
[2]:https://github.com/xiyannanfei/Project/blob/master/image/基础篇/201908062340.png
[3]:https://github.com/xiyannanfei/Project/blob/master/image/基础篇/201908062341.png
[4]:https://github.com/xiyannanfei/Project/blob/master/image/基础篇/201908062342.png
[5]:https://github.com/xiyannanfei/Project/blob/master/image/基础篇/201908062343.png
[6]:https://github.com/xiyannanfei/Project/blob/master/image/基础篇/201908062344.png
[7]:https://github.com/xiyannanfei/Project/blob/master/image/基础篇/201908062345.png



