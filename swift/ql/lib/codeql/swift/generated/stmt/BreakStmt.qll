// generated by codegen/codegen.py
import codeql.swift.elements.Element
import codeql.swift.elements.stmt.Stmt

class BreakStmtBase extends @break_stmt, Stmt {
  override string getAPrimaryQlClass() { result = "BreakStmt" }

  cached
  override Element getAChild() {
    none() or
    result = Stmt.super.getAChild()
  }

  string getTargetName() { break_stmt_target_names(this, result) }

  predicate hasTargetName() { exists(getTargetName()) }

  Stmt getTarget() {
    exists(Stmt x |
      break_stmt_targets(this, x) and
      result = x.resolve()
    )
  }

  predicate hasTarget() { exists(getTarget()) }
}
