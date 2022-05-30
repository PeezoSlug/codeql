// generated by codegen/codegen.py
import codeql.swift.elements.Element
import codeql.swift.elements.expr.Expr

class KeyPathExprBase extends @key_path_expr, Expr {
  override string getAPrimaryQlClass() { result = "KeyPathExpr" }

  cached
  override Element getAChild() {
    none() or
    result = Expr.super.getAChild() or
    result = getParsedRoot() or
    result = getParsedPath()
  }

  Expr getParsedRoot() {
    exists(Expr x |
      key_path_expr_parsed_roots(this, x) and
      result = x.resolve()
    )
  }

  predicate hasParsedRoot() { exists(getParsedRoot()) }

  Expr getParsedPath() {
    exists(Expr x |
      key_path_expr_parsed_paths(this, x) and
      result = x.resolve()
    )
  }

  predicate hasParsedPath() { exists(getParsedPath()) }
}
