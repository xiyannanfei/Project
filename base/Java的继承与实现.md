### 1.简介

java的四大特性：继承，抽象，封装，多态 

封装我们大多只知道get、set方法，其实他主要是为了隐藏对象属性，保证有些属性只存在类内部，而不被其他类修改或使用 

多态我个人理解是特性与共性的关系，子类可以有父类的属性与方法，但同时他也应该有自己的属性和方法，有时子类中拥有的父类方法不是他想要的，他就可以重写这些方法，或者编写特有的方法 

抽象就是把属性和方法抽出来，只声明而不实现，最常见的就是接口的使用 

而继承是大家最常见的，就不多说了，但是大家需要知道的是父类转换为子类并不是类型安全的，需要强制转换，而子类转换为父类会丢失自己特有的属性和方法

### 2.继承的使用

先看代码

```
public class Test01 {
         public static void carry(Father p, String input) {
         System.out.println("调用对象名：" + p.name());
         System.out.println(p.talk(input));
         }
     
     public static void main(String[] args) {
         carry(new Son(), TestUtils.GMS);
         carry(new Daughter(), TestUtils.GMS);
     }
}

class Father {
     public String name() {
         return getClass().getSimpleName();
     }
     
     String talk(String s) {
         return s;
     }
}

class Son extends Father {
     @Override
     String talk(String input) {
         return input.toUpperCase();
     }
}

class Daughter extends Father {
     @Override
     String talk(String input) {
         return Arrays.toString(input.split(" "));
     }
}
```

可以看出,父类拥有的方法,子类都有,并且子类可以重写他们,这里不建议父子类间的转换,我认为父子类更应该放在泛型约束中使用,这点我会在其他文章中另说

### 3.接口的使用

```
public class Test02 {

     public static void carry(TalkPower p, String input) {
         System.out.println("调用对象名：" + p.getClass().getName());
         System.out.println(p.talk(input));
         }

     public static void main(String[] args) {
         carry(new People(), TestUtils.GMS);
         carry(new Anima(), TestUtils.GMS);
     }
}

interface TalkPower {
     String talk(String input);
}

class People implements TalkPower {
     @Override
     public String talk(String input) {
         return input.toUpperCase();
     }
}

class Anima implements TalkPower {
     @Override
     public String talk(String input) {
         return Arrays.toString(input.split(" "));
     }
}
```

也是很简单的例子,对象都实现了同一个接口,我们可以直接声明接口的类型为泛型,在具体实例化的时候使用实现了这个接口的类

### 4.简述

其实接口和继承都可以很好的形成一种规范，但类只能继承一个,接口可以多个实现，我认为父类主要的是他提供了一个方法，并提供了一种默认的实现代码，而接口往往只声明了方法，不存在方法的实现(java8中可以有默认方法了,但用在函数式编程中)，这么设计意在形成一种规范，同时也是为了解决java不可以以方法为参数进行传递的设计

例如，我们可以在编写方法是要求传入的是某个接口，然后在方法中调用接口的方法，然后再让一些类实现这个接口，并完善各自的方法，然后将这些类作为参数传递给之前的方法，这也就形成了一个代码的传递

接口和继承还能和泛型有很好的配合，给代码提供更好的规范作用，减少异常的产生
