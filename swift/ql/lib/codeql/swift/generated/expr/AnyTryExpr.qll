// generated by codegen/codegen.py
import codeql.swift.elements.Element
import codeql.swift.elements.expr.Expr

class AnyTryExprBase extends @any_try_expr, Expr {
  cached
  override Element getAChild() {
    none() or
    result = Expr.super.getAChild() or
    result = getSubExpr()
  }

  Expr getSubExpr() {
    exists(Expr x |
      any_try_exprs(this, x) and
      result = x.resolve()
    )
  }
}
