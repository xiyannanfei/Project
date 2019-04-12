### const定义常变量后，该变量没有写权限，只有读权限

### ①const用于定义常变量时，要进行初始化

例如：

const int a=10; //合法

而const int a;  //非法

### ②数据类型对于const而言是透明的

例如：

const int a=10;   等价于 int const a=10;

const int *p1=&a;等价于int const *p1=&a;   但不等价于int *const  p1=&a;

### ③const用于封锁直接修饰的内容，该内容变为只读，该变量不能作为左值(左值：放在赋值号‘=’的左边，使用变量的写权限)

例如：

- 1）const int a=10;//const封锁a

a=100; //a作为左值，使用a的写权限，非法

int b=a; //使用a的读权限，合法

- 2）const int *p1=&a; //const修饰*p1,将p1作为左值合法，将*p1作为左值非法

例：p1=&b; //使用p1做左值，合法

*p1=200；//使用*p1做左值，非法

- 3）int * const p2=&a; //const修饰p2,将p2作为左值非法，将*p2作为左值合法

例：p2=&b;//使用p2做左值，非法

*p2=100;//使用*p2做左值，合法

- 4）const int * const p3=&a;//const分别修饰*p3,p3,将*p3，p2作为左值都非法

例：p3=&b;//使用p3做左值，非法

*p3=100;//使用*p3做左值，非法

### ④权限只能同等传递或者缩小传递

练习：

	int a = 10;                  
	int b = 20;                 
	const int ca = 10;     
	const int cb = 20;     
	int *p = &a;                //ok    
	p = &ca;                   //error      
	const int *cp1 = &a;         //ok     
	cp1 = &b;                //ok
	cp1 = &ca;                //ok      
 
	const int *cp2 = &ca;//ok
	int *const cp3 = &a; //ok
	int *const cp4 = &ca;//error
	const int *const cp5 = &a;//ok
	const int *const cp6 = &ca;//ok

