// generated by codegen/codegen.py
import codeql.swift.elements.Element
import codeql.swift.elements.expr.Expr

class UnresolvedDotExprBase extends @unresolved_dot_expr, Expr {
  override string getAPrimaryQlClass() { result = "UnresolvedDotExpr" }

  cached
  override Element getAChild() {
    none() or
    result = Expr.super.getAChild()
  }
}
