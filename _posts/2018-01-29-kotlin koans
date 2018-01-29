---
layout: post
date: 2018-01-29 12:39:00 +0800
title: kotlin koans
nocomments: false
---

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

val相当于java中的final，值在初始化时确定，之后不可变，var是可变的。
