// generated by codegen/codegen.py
private import codeql.swift.generated.Synth
private import codeql.swift.generated.Raw
import codeql.swift.elements.pattern.Pattern

class ParenPatternBase extends Synth::TParenPattern, Pattern {
  override string getAPrimaryQlClass() { result = "ParenPattern" }

  Pattern getImmediateSubPattern() {
    result =
      Synth::convertPatternFromDb(Synth::convertParenPatternToDb(this)
            .(Raw::ParenPattern)
            .getSubPattern())
  }

  final Pattern getSubPattern() { result = getImmediateSubPattern().resolve() }
}
