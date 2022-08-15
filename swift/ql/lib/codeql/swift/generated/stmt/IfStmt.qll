// generated by codegen/codegen.py
private import codeql.swift.generated.Synth
private import codeql.swift.generated.Raw
import codeql.swift.elements.stmt.LabeledConditionalStmt
import codeql.swift.elements.stmt.Stmt

class IfStmtBase extends Synth::TIfStmt, LabeledConditionalStmt {
  override string getAPrimaryQlClass() { result = "IfStmt" }

  Stmt getImmediateThen() {
    result = Synth::convertStmtFromDb(Synth::convertIfStmtToDb(this).(Raw::IfStmt).getThen())
  }

  final Stmt getThen() { result = getImmediateThen().resolve() }

  Stmt getImmediateElse() {
    result = Synth::convertStmtFromDb(Synth::convertIfStmtToDb(this).(Raw::IfStmt).getElse())
  }

  final Stmt getElse() { result = getImmediateElse().resolve() }

  final predicate hasElse() { exists(getElse()) }
}
