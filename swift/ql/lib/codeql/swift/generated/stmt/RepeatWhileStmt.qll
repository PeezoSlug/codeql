// generated by codegen/codegen.py
private import codeql.swift.generated.Synth
private import codeql.swift.generated.Raw
import codeql.swift.elements.expr.Expr
import codeql.swift.elements.stmt.LabeledStmt
import codeql.swift.elements.stmt.Stmt

class RepeatWhileStmtBase extends Synth::TRepeatWhileStmt, LabeledStmt {
  override string getAPrimaryQlClass() { result = "RepeatWhileStmt" }

  Expr getImmediateCondition() {
    result =
      Synth::convertExprFromDb(Synth::convertRepeatWhileStmtToDb(this)
            .(Raw::RepeatWhileStmt)
            .getCondition())
  }

  final Expr getCondition() { result = getImmediateCondition().resolve() }

  Stmt getImmediateBody() {
    result =
      Synth::convertStmtFromDb(Synth::convertRepeatWhileStmtToDb(this)
            .(Raw::RepeatWhileStmt)
            .getBody())
  }

  final Stmt getBody() { result = getImmediateBody().resolve() }
}
