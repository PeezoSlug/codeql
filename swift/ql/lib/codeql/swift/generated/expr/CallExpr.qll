// generated by codegen/codegen.py
private import codeql.swift.generated.Synth
private import codeql.swift.generated.Raw
import codeql.swift.elements.expr.ApplyExpr

class CallExprBase extends Synth::TCallExpr, ApplyExpr {
  override string getAPrimaryQlClass() { result = "CallExpr" }
}
