---
layout: post
date: 2017-09-17 14:44:39 +0800
title: ApplicationContext的启动过程
nocomments: false
---

未完待续。

<!-- more -->

关键词：
- BeanFactory ApplicationEventPublisherAware
- ApplicationContextAware
- BeanDefinitionRegistry
- BeanFactory
- BeanDefinition

先看下三个目标类的类图：
<img alt="ApplicationContext" src="/assets/img/ApplicationContext.png" width="800" height="250"/>

<img alt="AnnotationConfigApplicationContext" src="/assets/img/AnnotationConfigApplicationContext.png" width="800" height="300"/>

<img alt="ClassPathXmlApplicationContext" src="/assets/img/ClassPathXmlApplicationContext.png" width="900" height="300"/>

# 1. AnnotationConfigApplicationContext

来看下默认构造函数：
```java
public AnnotationConfigApplicationContext(Class<?>... annotatedClasses) {
    this();
    register(annotatedClasses);
    refresh();
}

// AnnotationConfigApplicationContext
public AnnotationConfigApplicationContext() {
    this.reader = new AnnotatedBeanDefinitionReader(this);
    this.scanner = new ClassPathBeanDefinitionScanner(this);
}
```

## 1.1 register(annotatedClasses)

看下register做了什么事？
```java
// org.springframework.context.annotation.AnnotationConfigApplicationContext#register
public void register(Class<?>... annotatedClasses) {
    Assert.notEmpty(annotatedClasses, "At least one annotated class must be specified");
    this.reader.register(annotatedClasses);
}
```

正好是AnnotatedBeanDefinitionReader的register方法。那么这个方法具体干了啥呢？
```java
// org.springframework.context.annotation.AnnotatedBeanDefinitionReader#register
public void register(Class<?>... annotatedClasses) {
    for (Class<?> annotatedClass : annotatedClasses) {
        registerBean(annotatedClass);
    }
}

public void registerBean(Class<?> annotatedClass) {
    registerBean(annotatedClass, null, (Class<? extends Annotation>[]) null);
}

public void registerBean(Class<?> annotatedClass, String name, Class<? extends Annotation>... qualifiers) {
    // 用Class构造beanDefintion
    AnnotatedGenericBeanDefinition abd = new AnnotatedGenericBeanDefinition(annotatedClass);
    // 检查Conditional注解对应的类是否满足，不满足跳过
    if (this.conditionEvaluator.shouldSkip(abd.getMetadata())) {
        return;
    }

    // scope信息及代理模式ScopedProxyMode
    ScopeMetadata scopeMetadata = this.scopeMetadataResolver.resolveScopeMetadata(abd);
    abd.setScope(scopeMetadata.getScopeName());
    // bean命名：Component/Named等注解指定的名字；未指定时使用类名，内部类用'.'分隔
    String beanName = (name != null ? name : this.beanNameGenerator.generateBeanName(abd, this.registry));
    AnnotationConfigUtils.processCommonDefinitionAnnotations(abd);
    if (qualifiers != null) {
        for (Class<? extends Annotation> qualifier : qualifiers) {
            if (Primary.class == qualifier) {
                abd.setPrimary(true);
            }
            else if (Lazy.class == qualifier) {
                abd.setLazyInit(true);
            }
            else {
                // 自自定义的注解
                abd.addQualifier(new AutowireCandidateQualifier(qualifier));
            }
        }
    }

    BeanDefinitionHolder definitionHolder = new BeanDefinitionHolder(abd, beanName);
    // 获取代理类的beanDefinition，隐含注册目标类beanDefinition
    definitionHolder = AnnotationConfigUtils.applyScopedProxyMode(scopeMetadata, definitionHolder, this.registry);
    // 注册beanDefinition
    BeanDefinitionReaderUtils.registerBeanDefinition(definitionHolder, this.registry);
}
```

到这里基本没啥问题了，register负责注册配置类的beanDefiniton。在这个过程中，会根据配置细粒度地进行配置beanDefinition的条件注册，以及创建并注册代理类beanDefinition。

## 1.2 refresh()

[tbd]