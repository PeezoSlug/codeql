// generated by codegen/codegen.py
import codeql.swift.elements.Element
import codeql.swift.elements.expr.ImplicitConversionExpr

class UnderlyingToOpaqueExprBase extends @underlying_to_opaque_expr, ImplicitConversionExpr {
  override string getAPrimaryQlClass() { result = "UnderlyingToOpaqueExpr" }

  cached
  override Element getAChild() {
    none() or
    result = ImplicitConversionExpr.super.getAChild()
  }
}
