// generated by codegen/codegen.py
import codeql.swift.elements.Element
import codeql.swift.elements.stmt.BraceStmt
import codeql.swift.elements.decl.GenericContext
import codeql.swift.elements.decl.ParamDecl
import codeql.swift.elements.decl.ValueDecl

class AbstractFunctionDeclBase extends @abstract_function_decl, GenericContext, ValueDecl {
  cached
  override Element getAChild() {
    none() or
    result = GenericContext.super.getAChild() or
    result = ValueDecl.super.getAChild() or
    result = getBody() or
    result = getParam(_)
  }

  string getName() { abstract_function_decls(this, result) }

  BraceStmt getBody() {
    exists(BraceStmt x |
      abstract_function_decl_bodies(this, x) and
      result = x.resolve()
    )
  }

  predicate hasBody() { exists(getBody()) }

  ParamDecl getParam(int index) {
    exists(ParamDecl x |
      abstract_function_decl_params(this, index, x) and
      result = x.resolve()
    )
  }

  ParamDecl getAParam() { result = getParam(_) }

  int getNumberOfParams() { result = count(getAParam()) }
}
