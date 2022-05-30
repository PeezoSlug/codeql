// generated by codegen/codegen.py
import codeql.swift.elements.Element
import codeql.swift.elements.pattern.Pattern

class BindingPatternBase extends @binding_pattern, Pattern {
  override string getAPrimaryQlClass() { result = "BindingPattern" }

  cached
  override Element getAChild() {
    none() or
    result = Pattern.super.getAChild() or
    result = getSubPattern()
  }

  Pattern getSubPattern() {
    exists(Pattern x |
      binding_patterns(this, x) and
      result = x.resolve()
    )
  }
}
