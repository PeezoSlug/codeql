// generated by codegen/codegen.py
import codeql.swift.elements.Element
import codeql.swift.elements.expr.Expr

class DiscardAssignmentExprBase extends @discard_assignment_expr, Expr {
  override string getAPrimaryQlClass() { result = "DiscardAssignmentExpr" }

  cached
  override Element getAChild() {
    none() or
    result = Expr.super.getAChild()
  }
}
