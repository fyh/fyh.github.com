---
layout: post
date: 2018-01-29 12:39:00 +0800
title: kotlin koans
nocomments: false
---

# topics

- 函数式
- 泛型

# koans

- Comparable
- ClosedRange

# destructuring declarations

解构声明

```kotlin
val (name, age) = person
```

返回的name和age是两个独立的变量，对应的值通过对象的componentN拿到。

配合data class
```kotlin
data class Result(val result: Int, val status: Status)
fun function(...): Result {
    // computations
    
    return Result(result, status)
}

// Now, to use this function:
val (result, status) = function(...)
```

遍历map：

```kotlin
for ((key, value) in map) {
   // do something with the key and the value
}
```

# data class

```kotlin
data class Person(val name: String, val age: Int)
```

自动生成componentN,equals()/hashCode(),toString(),copy()方法。

copy函数：
```kotlin
fun copy(name: String = this.name, age: Int = this.age) = User(name, age)     
```

所以能够支持语法：
``kotlin
val jack = User(name = "Jack", age = 1)
val olderJack = jack.copy(age = 2)
```

# val 和 var

val: read only

val相当于java中的final，值在初始化时确定，之后不可变，var是可变的。

# property

# interface

```kotlin
interface MyInterface {
	fun bar()
	fun foo() {
		// body
	}
}

class Impl : MyInterface {
	override fun bar() {
		// body
	}
}
```

abstract property

# accessor

# properties

`obj.prop` 访问的是 accessor

自动类型推断：

```kotlin
val isEmpty get() = this.size == 0  // has type Boolean
```

set改成私有，或者依赖注入：
```kotlin
var setterVisibility: String = "abc"
    private set // the setter is private and has the default implementation

var setterWithAnnotation: Any? = null
    @Inject set // annotate the setter with Inject
```

backing property:
[Automatic vs Explicit Properties](https://blogs.msdn.microsoft.com/ericlippert/2009/01/14/automatic-vs-explicit-properties/)

```kotlin
private var _table: Map<String, Int>? = null
public val table: Map<String, Int>
    get() {
        if (_table == null) {
            _table = HashMap() // Type parameters are inferred
        }
        return _table ?: throw AssertionError("Set to null by another thread")
    }
```

编译期常量：
```kotlin
const val SUBSYSTEM_DEPRECATED: String = "This subsystem is deprecated"

@Deprecated(SUBSYSTEM_DEPRECATED) fun foo() { ... }
```

非空类型必须在构造函数中初始化。
如果想要通过依赖注入或者去掉这个限制，可以指定为latinit。

```kotlin
public class MyTest {
    lateinit var subject: TestSubject

    @SetUp fun setup() {
        subject = TestSubject()
    }

    @Test fun test() {
        subject.method()  // dereference directly
    }
}
```

检查lateinit是否已经初始化了：`.isInitialized`

覆盖父类的属性：`override`

# Any Nothing Unit

Unit是Any的子类，相当于java中的Void

Nothing是没有类型，没有也不能实例化

```kotlin
fun fail(): Nothing {
    throw RuntimeException("Something went wrong")
}
```

# TODO
```kotlin
@kotlin.internal.InlineOnly
public inline fun TODO(reason: String): Nothing = throw NotImplementedError("An operation is not implemented: $reason")
```
