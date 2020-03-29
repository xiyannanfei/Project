#### 一、简介
        Google Protocol Buffer(简称Protobuf)是Google公司内部的混合语言数据标准，用于RPC系统和持续数据存储系统。是一种轻便高效的可用于通讯协议、数据存储等领域的语言无关、平台无关、可扩展的序列化结构数据格式。

#### 二、特点
1.优点：
* 性能好/效率高，序列化和反序列化的时间开销都很小。（注：参看《全方位评测：Protobuf性能到底有没有比JSON快5倍？》 http://www.52im.net/thread-772-1-1.html）

* 支持向后兼容和向前兼容，协议中增加新域不会影响依赖原协议的客户端。

* 平台无关、语言无关、可扩展。

* 支持多种编程语言，目前支持Java、C++、Python、Java Lite、Ruby、JavaScript、Object-C、C#、Go。

2.缺点：
* 二进制格式导致可读性差，为了提高性能，protobuf采用二进制编码，可读性差。

* 缺乏自描述，二进制的协议内容必须配合.proto文件的定义才有含义。

#### 三、历史及版本
        Protobuf最初是在Google开发的，用以解决索引服务器的请求、响应协议。

        Protobuf现在是Google公司内部的通用语言数据标准，已经在使用的有超过48162种报文格式定义和超过12182个.proto文件。它们广泛用于RPC系统或持续的数据存储系统 。

        由于Google在开源protobuf之前，已经在使用protobuf的第二个版本，所以开源时定的是proto2(从V2.0.0开始)，目前的最新版本是proto3。

#### 四、语言规范
（proto3, 参看：https://developers.google.com/protocol-buffers/docs/proto3）

1.消息类型
* 定义一个消息，例如：
```java

syntax = "proto3";

message SearchRequest {
	string query = 1;
	int32 page_number = 2;
	int32 result_per_page = 3;
}
```

* 第一行指定了是使用proto3语法，如果没有这一行声明，protobuf编译器将假定你使用proto2语法。如果声明这一行的话，该声明必须是.proto文件的第一行（排除空行、注释行）。


* 消息类型使用message关键字声明。

* 消息类型中可以引用其他消息类型，例如：
```java

message SearchResponse {
  repeated Result results = 1;
}

message Result {
  string url = 1;
  string title = 2;
  repeated string snippets = 3;
}
```

2.字段类型
* 字段类型可以是普通基本类型，也可以是复杂类型（枚举、Map或其他消息类型）；

* 消息定义中的每个字段都有一个唯一的数字编号，这个编号在protobuf消息的二进制格式中标识域，所以一旦消息定义中使用，最好不要改动。另外，字段编号1到15使用一个字节编码（编号本身 + 域类型），编号16到2047使用两个字节，因此，应该将编号1到15分配给频繁使用的字段（记得为将来可能频繁使用的字段预留1到15之内的编号）；字段编号最小可以指定为1，最大可以指定为2的29次方 减1（536870911），不能使用编号19000到19999（这些是protobuf实现使用的）；

* 指定字段的限定符，在proto2中，required前缀表示该字段为必要字段（即在序列化和反序列化之前该字段已经被赋值），optional前缀标识可选字段。在proto3中，singular前缀标识该字段是可选或必要字段（该字段不能多于一个）。repeated前缀标识可重复字段,这样的字段可以重复出现多次（也可以是零次），重复值得次序是会被保存的。

* 保留字段（Reserved Fields）

        如果需要修改消息类型，比如删除一个字段、注释掉一个字段，后续的使用者如果重新使用这个字段编号，就会导致旧版本解析异常。可以将这些删除的字段的编号设置为reserved，这样如果后续有人使用这些字段编号，protobuf编译器将报错。标记方法示例如下：
```java

message Foo {
  reserved 2, 15, 9 to 11;
  reserved "foo", "bar";
}
```

注：上述标记标识字段编号2、15、9~11是保留的，不能被使用；字段名称”foo“、”bar“也是保留的。不能在一条reservced语句中，混合使用字段名和字段编号。reservced 字段名，在JSON 序列化时会引起问题。   

* Protobuf基本类型与其他语言类型的对照表

| proto Type | Notes                                    | C++ Type | Java Type  |
| ---------- | ---------------------------------------- | -------- | ---------- |
| double     |                                          | double   | double     |
| float      |                                          | float    | float      |
| int32      | Uses variable-length encoding. Inefficient for encoding negative numbers – if your field is likely to have negative values, use sint32 instead. | int32    | int        |
| int64      | Uses variable-length encoding. Inefficient for encoding negative numbers – if your field is likely to have negative values, use sint64 instead | int64    | long       |
| uint32     | Uses variable-length encoding            | uint32   | int        |
| uint64     | Uses variable-length encoding            | uint64   | long       |
| sint32     | Uses variable-length encoding. Signed int value. These more efficiently encode negative numbers than regular int32s | int32    | int        |
| sint64     | Uses variable-length encoding. Signed int value. These more efficiently encode negative numbers than regular int64s | int64    | long       |
| fixed32    | Always four bytes. More efficient than uint32 if values are often greater than 228 | uint32   |            |
| fixed64    | Always eight bytes. More efficient than uint64 if values are often greater than 256 | uint64   | long       |
| sfixed32   | Always four bytes                        | int32    | int        |
| sfixed64   | Always eight bytes                       | int64    |            |
| bool       |                                          | bool     | boolean    |
| string     | A string must always contain UTF-8 encoded or 7-bit ASCII text | string   | String     |
| bytes      | May contain any arbitrary sequence of bytes | string   | ByteString |

* 默认值

        如果待解析的消息中没有包含singular字段元素，解析时会被设置为默认值。

      对于string，默认值为空字符串；

      对于bytes,默认值为空bytes;

      对于bools，默认值为false;

      对于数字类型，默认值为0；

      对于枚举类型，默认值是第一个枚举元素（该元素标号必须为0）；

      对于消息域类型，不同的语言默认值不同。

      对于repeated类型的字段，默认值为空，不同语言里一般对应空列表。

* 枚举类型

        可以定义枚举类型的消息类型，也可以在消息中定义枚举类型的字段，例如：
```java

message SearchRequest {
  string query = 1;
  int32 page_number = 2;
  int32 result_per_page = 3;
  enum Corpus {
    UNIVERSAL = 0;
    WEB = 1;
    IMAGES = 2;
    LOCAL = 3;
    NEWS = 4;
    PRODUCTS = 5;
    VIDEO = 6;
  }
  Corpus corpus = 4;
}
```

注：
    枚举通常应该从0值开始，因为我们可以使用0作为默认值，也为了兼容proto2(第一个值为默认值)。

    枚举常量值必须在32位int值范围之内，负数的常量值是无效的。

    枚举可以定义在消息内部，也可以定义在外部（被用作消息类型），也可以在消息类型中引用其他消息类型中的定义的枚举，如：MessageType.EnumType。

可以定义不同的枚举常量使用相同的数字值，但需要设置allow_alias选项为true，不设置的话，会导致编译器报错。示例：

enum EnumAllowingAlias {
  option allow_alias = true;
  UNKNOWN = 0;
  STARTED = 1;
  RUNNING = 1;
}
enum EnumNotAllowingAlias {
  UNKNOWN = 0;
  STARTED = 1;
  // RUNNING = 1;  // Uncommenting this line will cause a compile error inside Google and a warning message outside.
}

* 在proto3中使用proto2消息类型定义

        导入proto2的消息类型，并在proto3的消息类型中使用也是可行的。但是proto2的枚举不能直接在proto3语法下使用，在导入的proto2消息类型中使用是没问题的。

* 消息类型嵌套定义

        可以在一个消息类型中嵌套定义其他的消息类型。可以嵌套定义多层。

* Any类型

        Any类型，允许在不定义消息类型的情况下以内嵌的方式使用消息。每一个Any类型都可以包含任意的可序列化的消息的二进制描述，通过为它们分配唯一的URL来区分类型，使用Any类型，需要导入google/protobuf/any.proto。例如：

```java
import "google/protobuf/any.proto";

message ErrorStatus {
  string message = 1;
  repeated google.protobuf.Any details = 2;
}
```
        Any类型默认的URL类型为type.googleapis.com/packagename.messagename.

不同的语言支持pack和unpack Any类型的值，在Java中，有pack()和unpack()方法，在C++中有PackFrom()和UnpackTo()方法，解析示例如下：
```java
// Storing an arbitrary message type in Any.
NetworkErrorDetails details = ...;
ErrorStatus status;
status.add_details()->PackFrom(details);

// Reading an arbitrary message from Any.
ErrorStatus status = ...;
for (const Any& detail : status.details()) {
  if (detail.Is<NetworkErrorDetails>()) {
    NetworkErrorDetails network_error;
    detail.UnpackTo(&network_error);
    ... processing network_error ...
  }
}
```

* Oneof类型

        如果在一个消息中，如果多个字段在某个时刻只有一个会被用到，使用oneof可以强制这种行为。同一时间只能设置oneof中的一个字段，一个字段被设置后自动清理oneof中的其他字段。

        注意：oneof字段不能被限定为repeated的。

示例：
```java
message SampleMessage {
  oneof test_oneof {
    string name = 4;
    SubMessage sub_message = 9;
  }
}
```

* Maps

        protobuf中声明map的语法为：map<key_type, value_type> map_field = N;

        key_type可以是整数或字符串类型，注意枚举类型是不能作为key_type的，value_map可以是除map之外的任意类型。

注：Map字段不能限定为repeated；

        map中值存储的顺序是未定义的，不能依赖这个顺序；

Protobuf中maps的替代方案是：
```java
message MapFieldEntry {
  key_type key = 1;
  value_type value = 2;
}

repeated MapFieldEntry map_field = N;
```

3..proto文件
（1）、多个消息类型可以定义在一个.proto文件中，通常相互关联的消息定义在一个文件中。

（2）、在文件中增加注释，采用C/C++风格，使用“//” 或者“/* ... */”语法。例如：

 

（3）、不同语言根据.proto文件生成的代码不同：

对C++来说，编译器会为每个.proto文件生成一个.h和.cc文件，其中每个消息类型对应一个类定义；

对Java来说，编译器会为每个.proto文件中的消息类型生成一个类（可能是一个.java文件或多个.java文件，取决于.proto的options），同时也会为每个消息类生成特定的构建器类；

对于C#来说，编译器为每个.proto文件生成一个.cs文件，其中每个消息类型对应一个类定义。

（4）、导入定义

        通过在一个.proto文件中导入其他的.proto文件，可以使用其他文件中的定义，导入方式如下所示：

import "myproject/other_protos.proto";
        默认情况下，只能使用直接导入的定义，如果要使用间接导入的定义，需要使用import public声明，例如：

// new.proto
// All definitions are moved here

// old.proto
// This is the proto that all clients are importing.
import public "new.proto";
import "other.proto";

// client.proto
import "old.proto";
// You use definitions from old.proto and new.proto, but not other.proto
注：protobuf编译器生成代码时会根据编译器命令行 -I/--proto_path指定的一系列路径去搜索导入文件，如果没有指定-I/--proto_path标记，将会搜索编译器调用的.proto文件指定的导入文件。通常应该设置--proto_path为项目的跟路径并且使用所有导入文件的全限定名来指定导入文件。

（5）、Packages

        可以在.proto文件中使用package声明，来避免消息类型的名字冲突。例如：

package foo.bar;
message Open { ... }
可以以如下方式使用：

message Foo {
  ...
  foo.bar.Open open = 1;
  ...
}
在C++中，Package声明限定，生成代码后会成为命名空间，比如：foo::bar；

在Java中，Package声明限定，生成代码后会成为Java包名，除非额外使用option java_package来指定java包名。

（6）定义服务

        如果想在一个RPC系统中使用消息类型，可以在.prpto文件中定义一个RPC服务接口。protobuf编译器将生成服务接口代码和stubs。定义示例如下：

service SearchService {
  rpc Search (SearchRequest) returns (SearchResponse);
}
        使用protobuf最简单地RPC系统是gRPC,一个Google开发的语言无关，平台无关的开源RPC系统，不使用gRPC,也可以选择其他的RPC实现。

（7）、JSON映射

        Proto3支持标准的Json编码，方便系统之间通过json共享数据。如果Json编码的元素缺失或者值为null,解析后将会为protobuf的默认值，如果域使用默认值，编码为Json时可能省略该元素保存空格。通常可以通过一些选项控制Json编码格式的输出细节。

来源： https://developers.google.com/protocol-buffers/docs/proto3#oneof-features

proto3	JSON	JSON example	Notes
message	object	{"fooBar": v, "g": null,…}	Generates JSON objects. Message field names are mapped to lowerCamelCase and become JSON object keys. If the json_name field option is specified, the specified value will be used as the key instead. Parsers accept both the lowerCamelCase name (or the one specified by the json_nameoption) and the original proto field name. null is an accepted value for all field types and treated as the default value of the corresponding field type.
enum	string	"FOO_BAR"	The name of the enum value as specified in proto is used. Parsers accept both enum names and integer values.
map<K,V>	object	{"k": v, …}	All keys are converted to strings.
repeated V	array	[v, …]	null is accepted as the empty list [].
bool	true, false	true, false	 
string	string	"Hello World!"	 
bytes	base64 string	"YWJjMTIzIT8kKiYoKSctPUB+"	JSON value will be the data encoded as a string using standard base64 encoding with paddings. Either standard or URL-safe base64 encoding with/without paddings are accepted.
int32, fixed32, uint32	number	1, -10, 0	JSON value will be a decimal number. Either numbers or strings are accepted.
int64, fixed64, uint64	string	"1", "-10"	JSON value will be a decimal string. Either numbers or strings are accepted.
float, double	number	1.1, -10.0, 0, "NaN","Infinity"	JSON value will be a number or one of the special string values "NaN", "Infinity", and "-Infinity". Either numbers or strings are accepted. Exponent notation is also accepted.
Any	object	{"@type": "url", "f": v, … }	If the Any contains a value that has a special JSON mapping, it will be converted as follows: {"@type": xxx, "value": yyy}. Otherwise, the value will be converted into a JSON object, and the "@type" field will be inserted to indicate the actual data type.
Timestamp	string	"1972-01-01T10:00:20.021Z"	Uses RFC 3339, where generated output will always be Z-normalized and uses 0, 3, 6 or 9 fractional digits. Offsets other than "Z" are also accepted.
Duration	string	"1.000340012s", "1s"	Generated output always contains 0, 3, 6, or 9 fractional digits, depending on required precision, followed by the suffix "s". Accepted are any fractional digits (also none) as long as they fit into nano-seconds precision and the suffix "s" is required.
Struct	object	{ … }	Any JSON object. See struct.proto.
Wrapper types	various types	2, "2", "foo", true,"true", null, 0, …	Wrappers use the same representation in JSON as the wrapped primitive type, except that null is allowed and preserved during data conversion and transfer.
FieldMask	string	"f.fooBar,h"	See fieldmask.proto.
ListValue	array	[foo, bar, …]	 
Value	value	 	Any JSON value
NullValue	null	 	JSON null
        Json输出的控制选项：

        * 在proto3中，默认情况下JSON输出会忽略保存默认值的字段，可以通过选项改变这种行为，使JSON输出保存默认值；

        * 在proto3中，JSON解析器默认会丢弃未知字段，可以通过选项控制在解析时忽略未知字段;

        * 在proto3中，默认JSON输出会转换域名为驼峰式地名字（形同Java驼峰变量名形式），可以选项控制按字段名输出。

        * 枚举值得默认JSON输出为字符串枚举值名称，可以选项控制输出为数字值。

（8）、选项声明

        java_package(file option) : 指定生成的Java类的包名；例如：option  java_package = "com.example.foo";

        java_multiple_files(file option): 将.proto文件中的消息类型定义成顶层的class，而不是默认的内部类。例如：option java_multiple_files = true;

        java_outer_classname(file option):指定.proto生成的最外层类的名称，默认是.proto文件名（转换为驼峰式后的样子）。例如：option java_outer_classname = "Ponycopter";

        optimize_for(file option) : 可以设置SPEED、CODE_SIZE或LITE_RUNTIME,默认会使SPEED的，这时protobuf编译器生成的代码将是性能最优化的，CODE_SIZE,编译器将生成代码量最小但性能稍差的代码，多用于包含大量.proto文件并且不需要全部都快速执行。LITE_RUNTIME:编译器仅生成依赖“lite”运行库的代码版本，通常对于受限平台（比如手机），仅生成少量的SPEED模式的API.

例如：option  optimize_for = CODE_SIZE;

        cc_enable_arenas(file option) : 为C++生成的代码开启空间分配；

        objc_class_prefix(file option) : 为Objective-C类添加前缀；

        deprecated(field option):设置为true，表示字段是废弃的，不能在新代码中使用，可以考虑使用reserved语句替代。

例如：int32 old_field = 6 [deprecated=true];

注：Protocol Buffers允许自定义选项。

（9）、代码生成

protoc --proto_path=IMPORT_PATH --cpp_out=DST_DIR --java_out=DST_DIR --python_out=DST_DIR --go_out=DST_DIR --ruby_out=DST_DIR --objc_out=DST_DIR --csharp_out=DST_DIR path/to/file.proto
4、兼容性
（1）、扩展消息类型

要遵循一下规则：

        * 不要改变已存在的域的字段编号；

        * 增加一下新字段，旧版本序列化的消息可以通过新版本生成的代码解析，新版本序列化的消息也可以通过旧版本生成的代码解析（新增加的字段会被 当做未知字段）

        * 当一个字段在你要更新的消息类型中不再使用时，可以将该域移除，需要修改限定符为reserved；将一个域重命名，需要添加前缀“OBSOLETE_”；

        * int32、uint32、int64、uint64、bool是兼容的，可以将字段类型从这些类型中的一个改变为另一个，这样做不会破坏向前向后兼容性，但要注意类型的截取；

        * sint32、sint64是兼容的，但是跟其他的整型不兼容。fixed32域sfixed32兼容，fixed64域sfixed64兼容；

        * enum类型与int32、uint32、int64、uint64兼容（注意值可能被截取）。但是注意不同语言在消息反序列化时的不同处理（比如，不在范围内的枚举常量值，能被保存到消息中，但是在消息解析时不同语言怎么呈现是不一样的）；

        * 改变一个单值为一个新的oneof限定的类型的一个字段，是安全的并且二进制兼容，移动多个字段到一个oneof类型中，只要这几个字段不会再同时使用就是安全的。但是将一个字段移动到一个已存在的oneof类型中是不安全的。



#### 五、命名规范
1、消息名与字段名
（1）、消息名采用大写开头的驼峰命名形式，例如：SongServerRequest

（2）、字段名采用下划线分离的小写形式，例如song_name

例如：

message SongServerRequest {
  required string song_name = 1;
}
使用这样的命名规范，生成的代码看起来如下：

C++:
  const string& song_name() { ... }
  void set_song_name(const string& x) { ... }

Java:
  public String getSongName() { ... }
  public Builder setSongName(String v) { ... }
2、枚举名
        枚举名使用大写开头的驼峰命名形式，枚举值采用下划线分隔的大写形式，例如

enum Foo {
  FIRST_VALUE = 0;
  SECOND_VALUE = 1;
}
3、服务名
        RPC服务接口，服务名、RPC接口名均采用大写开头的驼峰命名形式。例如：

service FooService {
  rpc GetSomething(FooRequest) returns (FooResponse);
}
