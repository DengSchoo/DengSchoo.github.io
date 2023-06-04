# 一、开发环境准备

## 下载

进入 [JDK 官方下载地址 (opens new window)](http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html)，根据自己的环境选择下载所需版本。

### 安装

windows 环境的 jdk 包是 exe 安装文件，启动后根据安装向导安装即可。

Linux 环境的 jdk 包，解压到本地即可。



> Linux多版本Java包管理：[SDKMAN](https://sdkman.io/)
>
> Win多版本工具：[如何在Windows中快速切换不同的Java版本 - Jaxu - 博客园 (cnblogs.com)](https://www.cnblogs.com/jaxu/p/14972722.html)

## 环境变量

### Windows

计算机 > 属性 > 高级系统设置 > 环境变量

添加以下环境变量：

`JAVA_HOME`：`C:\Program Files (x86)\Java\jdk1.8.0_91` （根据自己的实际路径配置）

`CLASSPATH`：`.;%JAVA_HOME%\lib\dt.jar;%JAVA_HOME%\lib\tools.jar;` （注意前面有个"."）

```
Path`：`%JAVA_HOME%\bin;%JAVA_HOME%\jre\bin;
```

### Linux

执行 `vi /etc/profile` ，编辑环境变量文件

添加两行：

```shell
export JAVA_HOME=path/to/java
export PATH=JAVA_HOME/bin:JAVA_HOME/jre/bin:
```

执行 `source /etc/profile` ，立即生效。

## 测试安装成功测试安装成功

执行命令 `java -version` ，如果安装成功，会打印当前 java 的版本信息。

### 开发工具

工欲善其事，必先利其器。编写 Java 程序，当然有必要选择一个合适的 IDE。

IDE（Integrated Development Environment，即集成开发环境）是用于提供程序开发环境的应用程序，一般包括代码编辑器、编译器、调试器和图形用户界面等工具。

常见的 Java IDE 如下：

- Eclipse - 一个开放源代码的、基于 Java 的可扩展开发平台。
- NetBeans - 开放源码的 Java 集成开发环境，适用于各种客户机和 Web 应用。
- IntelliJ IDEA - 在代码自动提示、代码分析等方面的具有很好的功能。
- MyEclipse - 由 Genuitec 公司开发的一款商业化软件，是应用比较广泛的 Java 应用程序集成开发环境。
- EditPlus - 如果正确配置 Java 的编译器“Javac”以及解释器“Java”后，可直接使用 EditPlus 编译执行 Java 程序。

### 第一个程序：Hello World

添加 HelloWorld.java 文件，内容如下：

```java
public class HelloWorld {
    public static void main(String[] args) {
        System.out.println("Hello World");
    }
}
```

执行后，控制台输出：

```text
Hello World
```

# 2.基础语法特性

### 2.1 注释

```java
public class HelloWorld {
    /*
     * JavaDoc 注释
     */
    public static void main(String[] args) {
        // 单行注释
        /* 多行注释：
           1. 注意点a
           2. 注意点b
         */
        System.out.println("Hello World");
    }
}
```

### 2.2 基础数据类型

#### 2.2.1 数据类型

- 值类型：
- 引用类型：
- 值类型VS引用类型：

#### 2.2.2 值类型

### 2.3 变量



### 2.4 数组



### 2.5 枚举



### 2.6 操作符



### 2.7 方法



### 2.8 控制语句



### 2.9 异常



### 2.10 泛型



### 2.11 反射



### 2.12 注解



### 2.13 序列化





# 深入理解Java基础数据类型



# Java面向对象



# Java方法详解



# Java数组详解



# Java枚举详解



# Java控制语句



# Java异常详解



# Java泛型详解



# Java反射和动态代理详解



# Java注解详解



# Java常用工具类详解



# Java String类型详解

