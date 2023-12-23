## STL用法

1. sort语法：

```c++
std::sort(points.begin(), points.end(), [](const auto& a, const auto& b) {
            return a[0] < b[0];
 });
```

2. 