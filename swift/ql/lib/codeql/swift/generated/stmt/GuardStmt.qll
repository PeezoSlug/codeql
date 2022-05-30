// generated by codegen/codegen.py
import codeql.swift.elements.Element
import codeql.swift.elements.stmt.BraceStmt
import codeql.swift.elements.stmt.LabeledConditionalStmt

class GuardStmtBase extends @guard_stmt, LabeledConditionalStmt {
  override string getAPrimaryQlClass() { result = "GuardStmt" }

  cached
  override Element getAChild() {
    none() or
    result = LabeledConditionalStmt.super.getAChild() or
    result = getBody()
  }

  BraceStmt getBody() {
    exists(BraceStmt x |
      guard_stmts(this, x) and
      result = x.resolve()
    )
  }
}
