// generated by codegen/codegen.py
private import codeql.swift.generated.Synth
private import codeql.swift.generated.Raw
import codeql.swift.elements.expr.Expr
import codeql.swift.elements.expr.LiteralExpr
import codeql.swift.elements.expr.OpaqueValueExpr
import codeql.swift.elements.expr.TapExpr

class InterpolatedStringLiteralExprBase extends Synth::TInterpolatedStringLiteralExpr, LiteralExpr {
  override string getAPrimaryQlClass() { result = "InterpolatedStringLiteralExpr" }

  OpaqueValueExpr getImmediateInterpolationExpr() {
    result =
      Synth::convertOpaqueValueExprFromDb(Synth::convertInterpolatedStringLiteralExprToDb(this)
            .(Raw::InterpolatedStringLiteralExpr)
            .getInterpolationExpr())
  }

  final OpaqueValueExpr getInterpolationExpr() {
    result = getImmediateInterpolationExpr().resolve()
  }

  final predicate hasInterpolationExpr() { exists(getInterpolationExpr()) }

  Expr getImmediateInterpolationCountExpr() {
    result =
      Synth::convertExprFromDb(Synth::convertInterpolatedStringLiteralExprToDb(this)
            .(Raw::InterpolatedStringLiteralExpr)
            .getInterpolationCountExpr())
  }

  final Expr getInterpolationCountExpr() { result = getImmediateInterpolationCountExpr().resolve() }

  final predicate hasInterpolationCountExpr() { exists(getInterpolationCountExpr()) }

  Expr getImmediateLiteralCapacityExpr() {
    result =
      Synth::convertExprFromDb(Synth::convertInterpolatedStringLiteralExprToDb(this)
            .(Raw::InterpolatedStringLiteralExpr)
            .getLiteralCapacityExpr())
  }

  final Expr getLiteralCapacityExpr() { result = getImmediateLiteralCapacityExpr().resolve() }

  final predicate hasLiteralCapacityExpr() { exists(getLiteralCapacityExpr()) }

  TapExpr getImmediateAppendingExpr() {
    result =
      Synth::convertTapExprFromDb(Synth::convertInterpolatedStringLiteralExprToDb(this)
            .(Raw::InterpolatedStringLiteralExpr)
            .getAppendingExpr())
  }

  final TapExpr getAppendingExpr() { result = getImmediateAppendingExpr().resolve() }

  final predicate hasAppendingExpr() { exists(getAppendingExpr()) }
}
