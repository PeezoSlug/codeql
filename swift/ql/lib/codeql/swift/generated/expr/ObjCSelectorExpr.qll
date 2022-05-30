// generated by codegen/codegen.py
import codeql.swift.elements.Element
import codeql.swift.elements.decl.AbstractFunctionDecl
import codeql.swift.elements.expr.Expr

class ObjCSelectorExprBase extends @obj_c_selector_expr, Expr {
  override string getAPrimaryQlClass() { result = "ObjCSelectorExpr" }

  cached
  override Element getAChild() {
    none() or
    result = Expr.super.getAChild() or
    result = getSubExpr()
  }

  Expr getSubExpr() {
    exists(Expr x |
      obj_c_selector_exprs(this, x, _) and
      result = x.resolve()
    )
  }

  AbstractFunctionDecl getMethod() {
    exists(AbstractFunctionDecl x |
      obj_c_selector_exprs(this, _, x) and
      result = x.resolve()
    )
  }
}
