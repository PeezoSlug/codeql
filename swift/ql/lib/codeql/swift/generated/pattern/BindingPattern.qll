// generated by codegen/codegen.py
private import codeql.swift.generated.Synth
private import codeql.swift.generated.Raw
import codeql.swift.elements.pattern.Pattern

class BindingPatternBase extends Synth::TBindingPattern, Pattern {
  override string getAPrimaryQlClass() { result = "BindingPattern" }

  Pattern getImmediateSubPattern() {
    result =
      Synth::convertPatternFromDb(Synth::convertBindingPatternToDb(this)
            .(Raw::BindingPattern)
            .getSubPattern())
  }

  final Pattern getSubPattern() { result = getImmediateSubPattern().resolve() }
}
