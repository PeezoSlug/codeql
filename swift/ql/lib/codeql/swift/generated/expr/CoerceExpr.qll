// generated by codegen/codegen.py
import codeql.swift.elements.Element
import codeql.swift.elements.expr.ExplicitCastExpr

class CoerceExprBase extends @coerce_expr, ExplicitCastExpr {
  override string getAPrimaryQlClass() { result = "CoerceExpr" }

  cached
  override Element getAChild() {
    none() or
    result = ExplicitCastExpr.super.getAChild()
  }
}
