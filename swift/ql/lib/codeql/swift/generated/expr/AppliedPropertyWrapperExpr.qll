// generated by codegen/codegen.py
import codeql.swift.elements.Element
import codeql.swift.elements.expr.Expr

class AppliedPropertyWrapperExprBase extends @applied_property_wrapper_expr, Expr {
  override string getAPrimaryQlClass() { result = "AppliedPropertyWrapperExpr" }

  cached
  override Element getAChild() {
    none() or
    result = Expr.super.getAChild()
  }
}
