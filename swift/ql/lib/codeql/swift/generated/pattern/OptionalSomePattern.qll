// generated by codegen/codegen.py
import codeql.swift.elements.Element
import codeql.swift.elements.pattern.Pattern

class OptionalSomePatternBase extends @optional_some_pattern, Pattern {
  override string getAPrimaryQlClass() { result = "OptionalSomePattern" }

  cached
  override Element getAChild() {
    none() or
    result = Pattern.super.getAChild() or
    result = getSubPattern()
  }

  Pattern getSubPattern() {
    exists(Pattern x |
      optional_some_patterns(this, x) and
      result = x.resolve()
    )
  }
}
