### 11.2

1. 修改Type.h，新增CHAR类型
2. 修改lexer.l

### 11.3

1. 修改Type.h，新增PTR类型；新增Bool
2. 修改Type.cpp，新增Char和Bool；新增`CharType::toStr()`和`PointerType::toStr()`
3. 修改SymbolTable.cpp lookup()和install()

4. 修改Ast.h
   - 语法树已有：Node, ExprNode, BinaryExpr, Constant, Id, ConstDeclStmt, StmtNode, CompoundStmt, SeqNode, DeclStmt, EfStmt, IfElseStmt, ReturnStmt, AssignStmt, FunctionDef, Ast
   - 修改：BinaryExpr, FunctionDef, 
   - 添加：UnaryExpr, ConstId, ExprStmt, Def, Defs, VarDeclStmt, ConstDeclStmt, WhileStmt, FunctionDecl, funcParams, funcParam, funcCall, funcCallStmt, funcCallParas, funcCallPara, OStreamFunction, IStreamFunction, BreakStmt, ContinueStmt
5. 修改Ast.cpp
   - 修改：BinaryExpr, FunctionDecl, 
   - 添加：UnaryExpr, ConstId, ExprStmt, Def, Defs, VarDeclStmt, ConstDeclStmt, WhileStmt, FunctionDecl, funcParams, funcParam, funcCall, funcCallStmt, funcCallParas, funcCallPara, OStreamFunction, IStreamFunction, BreakStmt, ContinueStmt
### 11.5
问题：
1. 47putint()
2. 48putint()
3. 56putint()
4. 50putint()
猜测：是lexer.l的问题
