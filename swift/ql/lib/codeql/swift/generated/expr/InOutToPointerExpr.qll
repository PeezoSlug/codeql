// generated by codegen/codegen.py
private import codeql.swift.generated.Synth
private import codeql.swift.generated.Raw
import codeql.swift.elements.expr.ImplicitConversionExpr

class InOutToPointerExprBase extends Synth::TInOutToPointerExpr, ImplicitConversionExpr {
  override string getAPrimaryQlClass() { result = "InOutToPointerExpr" }
}
