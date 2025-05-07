## 安装词法分析器 flex 和 语法分析器 bison

```shell
sudo apt install flex bison
```

- Flex：词法分析器，负责将 SQL 字符串分解为 token（如关键字、标识符、数字等）
- Bison：语法分析器，基于上下文无关文法（CFG），将 token 组合为结构化的语法树（AST）

使用它们可以从零构建出符合你需求的 SQL 语法解析器，具备完全的控制权和可扩展性。
